import json
import os
import pymongo
import logging
import base64
import requests
import traceback
import random
import string
import boto3
import uuid

from bson import Decimal128, json_util
from datetime import datetime
from pymongo.errors import DuplicateKeyError, ServerSelectionTimeoutError
from Crypto.Cipher import AES
from Crypto.Hash import SHA256
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    try:
        print(event)

        new_password = generate_password(20)
        body_dict = json.loads(event['body'])
        validate_payload_response = validate_payload(body_dict) # 1. Extracting data from the event payload

        if validate_payload_response['statusCode'] == 200:
            validate_payload_response_dict = json.loads(validate_payload_response['body'])

            id_value, source_value, target_value = validate_payload_response_dict['tenant_code'], validate_payload_response_dict['source_env'], validate_payload_response_dict['target_env']

            if isinstance(id_value, str):
                id_value = list(id_value)
                
            if isinstance(id_value, list):
                final_status = []
                final_body = []

                for tenant_code in id_value:
                    response_json = process_all_tenant_codes(tenant_code, source_value, target_value, new_password)
                    response_json = json.dumps(response_json)
                    response_dict = json.loads(response_json)
                    final_status.append(response_dict['statusCode'])

                    response_body_dict = json.loads(response_dict['body'])
                    activity_id = response_body_dict.get('activityId', None)
                    errors = response_body_dict.get('errors', [])
                    final_body.append({
                        "activityId": activity_id,
                        "tenantCode": tenant_code,
                        "errors": errors
                    })

                if all(value == 200 for value in final_status):
                    return create_response(200, final_body)
                else:
                    return create_response(500, final_body)
            else:
                error_message = f"Invalid tenant_code data type, only accepts <class 'list'>: {str(e)}"
                logger.error(error_message)
                traceback.print_exc()
                return create_response(500, {'errors': error_message})
        else:
            return validate_payload_response
        
    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})

def process_all_tenant_codes(id_value, source_value, target_value, new_password):
    client_conn_response = client_conn()  # Establishing connection to MongoDB

    if not client_conn_response:
        return {'statusCode': 500, 'message': 'Failed to establish database connection'}

    col = client_conn_response[1]

    read_from_db_response = read_from_db(col, id_value)  # Query the db based off the collection value

    if read_from_db_response['statusCode'] != 200:
        return read_from_db_response

    read_from_db_response_dict = json.loads(read_from_db_response['body'])

    decrypted_tenant_response = decrypt_function(read_from_db_response_dict, new_password)  # Decrypt the db response

    if decrypted_tenant_response['statusCode'] != 200:
        return decrypted_tenant_response

    decrypted_tenant_response_dict = json.loads(decrypted_tenant_response['body'])

    create_target_tenant_response = create_target_tenant(
        decrypted_tenant_response_dict['value'], id_value, source_value, target_value, new_password)  # Create the tenant in target_env

    return create_target_tenant_response

def validate_payload(body_dict):
    id = []
    target = None
    source = None
    valid_domains = []

    required_params = ['tenant_code', 'source_env', 'target_env']
    missing_params = []

    for key in required_params:
        if key not in body_dict:
            missing_params.append(f"'{key}' is a mandatory field.")
        else:
            value = body_dict[key]

            if key == 'source_env' and value:
                if value in [os.environ['OREGON_DEV'], os.environ['OREGON_STAGING'], os.environ['OREGON_PROD']]:
                    source = value
                    valid_domains = [os.environ['FRANKFURT_STAGING'], os.environ['FRANKFURT_PROD']]
                elif value in [os.environ['FRANKFURT_STAGING'], os.environ['FRANKFURT_PROD']]:
                    source = value
                    valid_domains = [os.environ['OREGON_DEV'], os.environ['OREGON_STAGING'], os.environ['OREGON_PROD']]
                else:
                    missing_params.append(f"'source_env' is invalid.")
            
            elif key == 'tenant_code' and value:
                if isinstance(value, list) and len(value) == 2:
                    id = value
                else:
                    missing_params.append("'tenant_code' must be a list containing exactly two values.")
            
            elif key == 'target_env' and value:
                if value in valid_domains:
                    target = value
                else:
                    missing_params.append(f"'target_env' is invalid or not in the valid domains: {valid_domains}")
            
            else:
                missing_params.append(f"'{key}' is empty or invalid.")

    if missing_params:
        return create_response(400, {'errors': missing_params})
    
    obj = {key: value for key, value in zip(required_params, [id, source, target])}
    return create_response(200, obj)

def client_conn():
    try:
        client = pymongo.MongoClient(host=os.environ['MONGODB_URI']+os.environ['MONGODB_NAME'])
        db = os.environ.get('MONGODB_NAME')
        client_db = client[db]
        client_col = client_db[os.environ.get('COLLECTION_NAME')]


        return client, client_col

    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})
 
def read_from_db(collection, id_value):
    try:
        result = collection.find_one({'_id': id_value})

        if result:
            result = json.loads(json_util.dumps(result))

            return create_response(200, result)
        else:
            print(f"No document found with tenant_code: {id_value}")
            return create_response(400, {'errors': f"No document found with tenant_code: {id_value}"})
        
    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})

def generate_password(length=20):
    characters = string.ascii_letters + string.digits
    password = ''.join(random.choice(characters) for _ in range(length))
    return password

def decrypt_function(payload, new_password):
    source_secret = os.environ['ENV_SECRET']
    kms_key = os.environ['KMS_KEY']

    if isinstance(payload, dict):
        try:
            if 'value' in payload and isinstance(payload['value'], dict):
                value_obj = payload['value']
                for key, value in value_obj.items():
                    if isinstance(value, dict):
                        for inner_key, inner_value in value.items():
                            if inner_key == 'userName' and key == 'tenant':
                                userName = str(uuid.uuid4()) # this should be inner_value, uuid is used for testing only
                            if inner_key == 'userPassword' and key == 'tenant':
                                value['userPassword'] = new_password # Generates new password
                                encrypted_password = encrypt(new_password, kms_key) # Encrypt the password using KMS
                                # store_secret(userName, encrypted_password, kms_key) # Store the newly created and encrypted password in secrets manager for future use
                                continue
                            if inner_key == 'userPassword' and key != 'tenant':
                                if 'userPasswordSalt' in value:
                                    decrypt_response = decrypt(inner_value, value['userPasswordSalt']+source_secret)
                                    value['userPassword'] = decrypt_response

            return create_response(200, payload)
        
        except Exception as e:
            error_message = f"An error occurred during password decryption: {str(e)}"
            logger.error(error_message)
            traceback.print_exc()
            return create_response(500, {'message': error_message})
    else:
        return create_response(400, {'message': 'Invalid payload format. Expected dictionary.'})

def create_target_tenant(payload, id_value, source_env, target_env, new_password):
    api_url = f"{target_env}{os.environ['API_ENDPOINT']}"
    username = None
    password = None

    if target_env == os.environ['OREGON_DEV']:
        username = os.environ['OREGON_DEV_USR']
        password = os.environ['OREGON_DEV_PWD']
    if target_env == os.environ['OREGON_STAGING']:
        username = os.environ['OREGON_STAGING_USR']
        password = os.environ['OREGON_STAGING_PWD']
    if target_env == os.environ['OREGON_PROD']:
        username = os.environ['OREGON_PROD_USR']
        password = os.environ['OREGON_PROD_PWD']
    if target_env == os.environ['FRANKFURT_STAGING']:
        username = os.environ['FRANKFURT_STAGING_USR']
        password = os.environ['FRANKFURT_STAGING_PWD']
    if target_env == os.environ['FRANKFURT_PROD']:
        username = os.environ['FRANKFURT_PROD_USR']
        password = os.environ['FRANKFURT_PROD_PWD']

    headers = {"ac-tenant-code": username}
    
    response = requests.post(api_url, json=payload, auth=(username, password), headers=headers)
    response_text = json.loads(response.text)
    response_text.pop('tenantCode', None)
    
    if response.status_code == 200:
        response_text['tenantPassword'] = new_password

        update_source_tenant_response = update_source_tenant(
        payload, id_value, source_env)  # Update the tenant

        if update_source_tenant_response['statusCode'] != 200:
            return update_source_tenant_response
        else:
            return create_response(response.status_code, response_text)
    else:
        logger.error(response.text)
        traceback.print_exc()
        return create_response(response.status_code, response_text)

def update_source_tenant(payload, tenant_code, source_value):
    domain_name = source_value
    api_url = f"{domain_name}{os.environ['API_ENDPOINT']}/{tenant_code}"
    username = None
    password = None

    if domain_name == os.environ['OREGON_DEV']:
        username = os.environ['OREGON_DEV_USR']
        password = os.environ['OREGON_DEV_PWD']
    if domain_name == os.environ['OREGON_STAGING']:
        username = os.environ['OREGON_STAGING_USR']
        password = os.environ['OREGON_STAGING_PWD']
    if domain_name == os.environ['OREGON_PROD']:
        username = os.environ['OREGON_PROD_USR']
        password = os.environ['OREGON_PROD_PWD']
    if domain_name == os.environ['FRANKFURT_STAGING']:
        username = os.environ['FRANKFURT_STAGING_USR']
        password = os.environ['FRANKFURT_STAGING_PWD']
    if domain_name == os.environ['FRANKFURT_PROD']:
        username = os.environ['FRANKFURT_PROD_USR']
        password = os.environ['FRANKFURT_PROD_PWD']

    headers = {"ac-tenant-code": username}
    
    response = requests.post(api_url, json=payload, auth=(username, password), headers=headers)
    response_text = json.loads(response.text)
    response_text.pop('tenantCode', None)
    
    if response.status_code == 200:
        return create_response(response.status_code, response_text)
    else:
        logger.error(response.text)
        traceback.print_exc()
        return create_response(response.status_code, response_text)

def encrypt(text_to_encrypt, key_id):
    """Encrypts a password using AWS KMS."""
    kms_client = boto3.client('kms')
    try:
        response = kms_client.encrypt(
            KeyId=key_id,
            Plaintext=text_to_encrypt.encode('utf-8')
        )
        encrypted_password = response['CiphertextBlob']
        return encrypted_password
    except ClientError as e:
        error_message = f"An error occured: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})

    # manual encryption
    # password = prepare_for_cipher(password)
    # key = create_key(secret)
    # cipher = AES.new(key, AES.MODE_ECB)
    # encrypted_bytes = cipher.encrypt(password)
    # return base64.b64encode(encrypted_bytes).decode()

def store_secret(secret_name, encrypted_password, key_id):
    """Stores the encrypted password in AWS Secrets Manager."""
    secrets_client = boto3.client('secretsmanager')
    try:
        secrets_client.create_secret(
            Name=secret_name,
            SecretBinary=encrypted_password,
            KmsKeyId=key_id
        )
        print(f"Secret {secret_name} stored successfully.")
    except ClientError as e:
        error_message = f"An error occured: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})

def decrypt(text_for_decrypt, secret):
    text_for_decrypt = text_for_decrypt.replace("\n", "")
    key = create_key(secret)
    cipher = AES.new(key, AES.MODE_ECB)
    decoded_value = base64.b64decode(text_for_decrypt)
    decrypted_value = cipher.decrypt(decoded_value).decode()
    final_decrypted_value = remove_trailing_zeros(decrypted_value)
    return final_decrypted_value

def create_key(secret):
    hasher = SHA256.new(secret.encode())
    return hasher.digest()[:16]

def prepare_for_cipher(text):
    text_bytes_count = len(text.encode())
    remaining = text_bytes_count % 16
    padding = (16 - remaining) * b"\0"
    return text.encode() + padding

def remove_trailing_zeros(decrypted_value):
    null_index = decrypted_value.find("\0")
    if null_index != -1:
        return decrypted_value[:null_index]
    else:
        return decrypted_value

def create_response(statusCode, body):
    response = {
        "statusCode": statusCode,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(body),
        "isBase64Encoded": False
    }
    return response
