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
        extract_from_oregon_response = extract_from_oregon(body_dict) # 1. Extracting data from the event payload

        if extract_from_oregon_response['statusCode'] == 200:
            extract_from_oregon_response_dict = json.loads(extract_from_oregon_response['body'])
            id_value, source_value, target_value = extract_from_oregon_response_dict['_id'], extract_from_oregon_response_dict['source_env'], extract_from_oregon_response_dict['target_env']
            client_conn_response = client_conn(source_value) # Establishing connection to MongoDBs

            if client_conn_response:
                client_oregon, oregon_col = client_conn_response[0], client_conn_response[1]
                oregon_connection = oregon_conn(client_oregon) # Check oregon connection status 

                if oregon_connection['statusCode'] == 200:
                    read_from_oregon_response = read_from_oregon(oregon_col, id_value) # Query the oregon region

                    if read_from_oregon_response['statusCode'] == 200:
                        read_from_oregon_response_dict = json.loads(read_from_oregon_response['body'])

                        decrypted_tenant_response = decrypt_function(read_from_oregon_response_dict, source_value) # Decrypt the oregon response

                        if decrypted_tenant_response['statusCode'] == 200:
                            decrypted_tenant_response_dict = json.loads(decrypted_tenant_response['body'])

                            create_frankfurt_tenant_response = create_frankfurt_tenant(target_value, decrypted_tenant_response_dict['value'])

                            return create_frankfurt_tenant_response
                        else:
                            return decrypted_tenant_response

                    else:
                        return read_from_oregon_response
    
                else:
                    return create_response(500, {'errors': 'Failed to establish MongoDB connection during initialization.'})
                
            else:
                return client_conn_response
        else:
            return extract_from_oregon_response
        
    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})

def extract_from_oregon(body_dict):
    id = None
    source = None
    target = None

    required_params = ['_id', 'source_env', 'target_env']
    missing_params = []

    valid_source = [os.environ['OREGON_DEV'], os.environ['OREGON_STAGING'], os.environ['OREGON_PROD']]
    valid_target = [os.environ['FRANKFURT_STAGING'], os.environ['FRANKFURT_PROD']]

    for key in required_params:
        if key not in body_dict:
            missing_params.append(f"'{key}' is mandatory field.")
        else:
            value = body_dict[key]
            if key == '_id' and value:
                id = value
            elif key == 'source_env' and value in valid_source:
                source = value
            elif key == 'target_env' and value in valid_target:
                target = value
            else:
                missing_params.append(f"'{key}' cannot be empty or invalid.")

    if missing_params:
        return create_response(400, {'errors': missing_params})
    
    obj = {key: value for key, value in zip(required_params, [id, source, target])}
    return create_response(200, obj)

def client_conn(source_env):
    source_valid = True

    try:
        # Oregon
        if source_env == os.environ['OREGON_DEV']:
            client_oregon = pymongo.MongoClient(host=os.environ['OREGON_DEV_URI']+os.environ['OREGON_DEV_DB'])
            db = os.environ.get('OREGON_DEV_DB')
            oregon_db = client_oregon[db]
            oregon_col = oregon_db[os.environ.get('COLLECTION_NAME')]
        elif source_env == os.environ['OREGON_STAGING']:
            client_oregon = pymongo.MongoClient(host=os.environ['OREGON_STAGING_URI']+os.environ['OREGON_STAGING_DB'])
            db = os.environ.get('OREGON_STAGING_DB')
            oregon_db = client_oregon[db]
            oregon_col = oregon_db[os.environ.get('COLLECTION_NAME')]
        elif source_env == os.environ['OREGON_PROD']:
            client_oregon = pymongo.MongoClient(host=os.environ['OREGON_PROD_URI']+os.environ['OREGON_PROD_DB'])
            db = os.environ.get('OREGON_PROD_DB')
            oregon_db = client_oregon[db]
            oregon_col = oregon_db[os.environ.get('COLLECTION_NAME')]
        else:
            source_valid = False

        # Return values
        if not (source_valid):
            return False
        else:
            return client_oregon, oregon_col

    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})
    
def check_conn(client):
    try:
        client.server_info()
        return create_response(200, {'message': 'MongoDB server is reachable.'})

    except ServerSelectionTimeoutError:
        return create_response(500, {'errors': 'Connection to MongoDB server timed out. Check your connection settings and server availability.'})

    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})

def oregon_conn(client_oregon):
    oregon_status = check_conn(client_oregon)
    if oregon_status['statusCode'] == 200:
        return oregon_status
    else:
        return create_response(500, {'errors': 'Failed to establish MongoDB connection with Oregon during initialization.'})

def read_from_oregon(collection, id_value):
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

def decrypt_function(payload, source_env):
    source_secret = None

    if source_env == os.environ['OREGON_DEV']:
        source_secret = os.environ['OREGON_DEV_SECRET']
    if source_env == os.environ['OREGON_STAGING']:
        source_secret = os.environ['OREGON_STAGING_SECRET']
    if source_env == os.environ['OREGON_PROD']:
        source_secret = os.environ['OREGON_PROD_SECRET']

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

def create_frankfurt_tenant(target_env, payload):
    api_url = f"{target_env}{os.environ['API_ENDPOINT']}"

    if target_env == os.environ['FRANKFURT_STAGING']:
        username = os.environ['FRANKFURT_STAGING_USR']
        password = os.environ['FRANKFURT_STAGING_PWD']
    elif target_env == os.environ['FRANKFURT_PROD']:
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
