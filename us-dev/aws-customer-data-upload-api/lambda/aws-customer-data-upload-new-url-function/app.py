import json
import boto3
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    
    file_path = 'path_to_your_file'
    bucket_name = 'your_bucket_name'
    object_key = 'desired_key_name_in_bucket'

    try:
        s3.upload_file(file_path, bucket_name, object_key)
        print(f"File uploaded successfully to bucket: {bucket_name} with key: {object_key}")
        return {
            'statusCode': 200,
            'body': 'File uploaded successfully'
        }
    except Exception as e:
        print(f"Error uploading file: {e}")
        return {
            'statusCode': 500,
            'body': 'Error uploading file'
        }
    
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
