import json
import boto3
import os
import uuid

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    print(event)
    # Extracting bucket name and object key from the event
    bucket_name = 'aws-customer-data-upload-bucket'
    object_key = str(uuid.uuid4())  # Generate a unique object key

    # Generate a pre-signed URL for uploading the file
    presigned_url = s3_client.generate_presigned_url(
        'put_object',
        Params={'Bucket': bucket_name, 'Key': object_key},
        ExpiresIn=3600  # URL expires in 1 hour
    )
    
    # Extracting parameters from the event
    file_content = 'text/plain'
    content_type = 'text/plain'
    
    upload_to_s3_response = upload_to_s3(presigned_url, object_key, file_content, content_type)

    return {
        'statusCode': 200,
        'body': json.dumps({'response': upload_to_s3_response, 'object_key': object_key})
    }

def upload_to_s3(presigned_url, object_key, file_content, content_type):
    # Upload the file to S3 using the pre-signed URL
    response = s3_client.put_object(
        Bucket='aws-customer-data-upload-bucket',
        Key=object_key,
        Body=file_content,
        ContentType=content_type
    )

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'File uploaded successfully', 'response': response})
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
