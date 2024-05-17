import os
import pymongo
import json
import boto3
import logging
import traceback

from bson import Decimal128, json_util

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def lambda_handler(event, context):
    try:
        print(event)

        if 'queryStringParameters' in event:
            query_params = event['queryStringParameters']

        mongodb_url = None
        mongodb_name = None

        if query_params['region_env'] == 'us-dev':
            mongodb_url = os.environ['OREGON_DEV_URI']
            mongodb_name = os.environ['OREGON_DEV_DB']

        if query_params['region_env'] == 'us-stage':
            mongodb_url = os.environ['OREGON_STAGE_URI']
            mongodb_name = os.environ['OREGON_STAGE_DB']

        if query_params['region_env'] == 'us-prod':
            mongodb_url = os.environ['OREGON_PROD_URI']
            mongodb_name = os.environ['OREGON_PROD_DB']

        if query_params['region_env'] == 'eu-stage':
            mongodb_url = os.environ['FRANKFURT_STAGE_URI']
            mongodb_name = os.environ['FRANKFURT_STAGE_DB']

        if query_params['region_env'] == 'eu-prod':
            mongodb_url = os.environ['FRANKFURT_PROD_URI']
            mongodb_name = os.environ['FRANKFURT_PROD_DB']

        client = pymongo.MongoClient(host=mongodb_url+mongodb_name)

        conn_status = check_conn(client)
        if conn_status['statusCode'] != 200:
            return conn_status
            
        db = client[mongodb_name]

        collection_value, other_key, other_value = extract_values_from_event(query_params)

        if collection_value is not None:
            collection_name = db[collection_value]

            if collection_value not in db.list_collection_names():
                error_message = f"Collection '{collection_value}' does not exist within the database '{mongodb_name}'"
                logger.error(error_message)
                traceback.print_exc()
                return create_response(404, {'errors': error_message})

            if other_value:
                return query_by_id(collection_name, other_key, other_value)
            else:
                error_message = "Missing or invalid value in the event"
                logger.error(error_message)
                return create_response(400, {'errors': error_message})
        else:
            error_message = "The collection key is not present in the paramaters."
            logger.error(error_message)
            traceback.print_exc()
            return create_response(404, {'errors': error_message})
    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(500, {'errors': error_message})
    except pymongo.errors.CollectionInvalid:
        error_message = f"Collection '{collection_name}' does not exist within the database '{mongodb_name}'"
        logger.error(error_message)
        traceback.print_exc()
        return create_response(404, {'errors': error_message})
    
def check_conn(client):
    return create_response(200 if client.admin.command('ping')['ok'] == 1 else 500, {'message': 'MongoDB server is reachable' if client.admin.command('ping')['ok'] == 1 else 'MongoDB server is not reachable'})

def extract_values_from_event(body_dict):
    collection_value = None
    other_key = None
    other_value = None
    collection_found = False

    for key, value in body_dict.items():
        if key == "collection" and not collection_found:
            collection_value = value
            collection_found = True
        else:
            if not other_key:
                other_key = key
                other_value = value
            else:
                break
                
    return collection_value, other_key, other_value
    
def query_by_id(collection, other_key, other_value):
    cursor = collection.find({other_key: other_value})
    result = list(cursor)

    if result:
        result = json.loads(json_util.dumps(result))
        
        tenant_config_params = ["userPassword", "userPasswordSalt", "password","publicKey","privateKey","appAccessKey"]
        system_config_params = ["userPassword", "userPasswordSalt", "password","headerPassword", "headerPasswordSalt", "containerPassword","containerPasswordSalt", "certificatePassword", "certificatePasswordSalt","fnUserPassword", "callbackPassword", "callbackPasswordSalt","encryptionKey","privateKey"]
        tenant_configuration_params = ["accessKey", "secretKey", "k8sBucketAccessKey","k8sBucketSecretKey", "salt", "apiAccountPassword","securityPin", "certificatePassword", "certificatePasswordSalt","fnUserPassword", "callbackPassword", "callbackPasswordSalt","clientSecret","encryptedFields","keyFile","appAccessKey","key","keyPassword","password","publicKey","privateKey"]
        provider_cred_params = ["password", "salt", "encryptedFields","certificate","certificatePassword","developerKey","certificate","privateKey","privateKeyPassword"]
        provider_agreements_params = ["password", "salt", "encryptedFields"]

        for document in result:
            check_and_mask_keys(document, tenant_config_params)
            check_and_mask_keys(document, system_config_params)
            check_and_mask_keys(document, tenant_configuration_params)
            check_and_mask_keys(document, provider_cred_params)
            check_and_mask_keys(document, provider_agreements_params)

        return create_response(200, result)
    else:
        error_message = f"No document found with {other_key}: {other_value}"
        print(f"No document found with {other_key}: {other_value}")
        traceback.print_exc()
        return create_response(404, {'errors': error_message})
    
def check_and_mask_keys(data, keys, mask_string="*****"):
    if isinstance(data, dict):
        for key, value in data.items():
            if key in keys:
                data[key] = mask_string
            if isinstance(value, (dict, list)):
                check_and_mask_keys(value, keys, mask_string)
    elif isinstance(data, list):
        for item in data:
            check_and_mask_keys(item, keys, mask_string)

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