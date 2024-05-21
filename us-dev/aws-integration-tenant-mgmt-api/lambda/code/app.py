import json
import os
import pymongo
import logging
import base64
import requests
import traceback

from bson import Decimal128, json_util
from datetime import datetime
from pymongo.errors import DuplicateKeyError, ServerSelectionTimeoutError
from Crypto.Cipher import AES
from Crypto.Hash import SHA256

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def lambda_handler(event, context):
    try:
        print(event)

        body_dict = json.loads(event['body'])
        validate_payload_response = validate_payload(body_dict) # 1. Extracting data from the event payload

        if validate_payload_response['statusCode'] == 200:
            validate_payload_response_dict = json.loads(validate_payload_response['body'])

            id_value, target_value = validate_payload_response_dict['_id'], validate_payload_response_dict['target_env']
            client_conn_response = client_conn() # Establishing connection to MongoDB

            if client_conn_response:
                col = client_conn_response[1]

                read_from_db_response = read_from_db(col, id_value) # Query the db based off the collection value

                if read_from_db_response['statusCode'] == 200:
                    read_from_db_response_dict = json.loads(read_from_db_response['body'])

                    decrypted_tenant_response = decrypt_function(read_from_db_response_dict) # Decrypt the db response

                    if decrypted_tenant_response['statusCode'] == 200:
                        decrypted_tenant_response_dict = json.loads(decrypted_tenant_response['body'])

                        create_tenant_response = create_tenant(target_value, decrypted_tenant_response_dict['value']) # Create the tenant using the integration-tenant-service's API deployed in the target env

                        return create_tenant_response
                    else:
                        return decrypted_tenant_response

                else:
                    return read_from_db_response
                
            else:
                return client_conn_response

        else:
            return validate_payload_response
        
    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})

def validate_payload(body_dict):
    id = None
    source = None
    target = None

    required_params = ['_id', 'target_env']
    missing_params = []

    valid_domains = [os.environ['OREGON_DEV'], os.environ['OREGON_STAGING'], os.environ['OREGON_PROD'], os.environ['FRANKFURT_STAGING'], os.environ['FRANKFURT_PROD']]

    for key in required_params:
        if key not in body_dict:
            missing_params.append(f"'{key}' is a mandatory field.")
        else:
            value = body_dict[key]
            if key == '_id' and value:
                id = value
            elif key == 'target_env' and value in valid_domains:
                target = value
            else:
                missing_params.append(f"'{key}' is invalid or empty.")

    if missing_params:
        return create_response(400, {'errors': missing_params})
    
    obj = {key: value for key, value in zip(required_params, [id, target])}
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
            print(f"No document found with _id: {id_value}")
            return create_response(400, {'errors': f"No document found with _id: {id_value}"})
        
    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})

def decrypt_function(payload):
    source_secret = os.environ['ENV_SECRET']

    if isinstance(payload, dict):
        try:
            if 'value' in payload and isinstance(payload['value'], dict):
                value_obj = payload['value']
                for key, value in value_obj.items():
                    if isinstance(value, dict):
                        for inner_key, inner_value in value.items():
                            if inner_key == 'userPassword' and key == 'tenant':
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

def create_tenant(target_env, payload):
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
    
    if response.status_code == 200:
        return create_response(response.status_code, json.loads(response.text))
    else:
        logger.error(response.text)
        traceback.print_exc()
        return create_response(response.status_code, json.loads(response.text))

def encrypt(text_to_encrypt, secret):
    text_to_encrypt = prepare_for_cipher(text_to_encrypt)
    key = create_key(secret)
    cipher = AES.new(key, AES.MODE_ECB)
    encrypted_bytes = cipher.encrypt(text_to_encrypt)
    return base64.b64encode(encrypted_bytes).decode()

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
