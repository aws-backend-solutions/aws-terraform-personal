import json
import boto3
import requests

s3 = boto3.client('s3')

def lambda_handler(event, context):
    print(event)
    body = json.loads(event['body'])
    attachment_url = body['attachment']['content']
    file_name = body['attachment']['filename']
    content_type = body['attachment']['mimeType']
    bucket_name = 'aws-customer-data-upload-bucket'
    object_key = file_name
    
    attachment_content = download_attachment(attachment_url)
    if attachment_content:
        upload_to_s3(attachment_content, file_name, content_type, bucket_name, object_key)
    else:
        print('Failed to download attachment from URL')

def upload_to_s3(file_content, file_name, content_type, bucket_name, object_key):
    try:
        s3.put_object(Body=file_content, Bucket=bucket_name, Key=object_key, ContentType=content_type)
        response = {
            'statusCode': 200,
            'body': json.dumps({'message': f"File '{file_name}' uploaded successfully"})
        }
    except Exception as e:
        response = {
            'statusCode': 500,
            'body': json.dumps({'error': f"Error uploading file: {str(e)}"})
        }
    
    print(response)
    return response

def download_attachment(attachment_url):
    response = requests.get(attachment_url)
    if response.status_code == 200:
        return response.content
    else:
        # Handle error (e.g., attachment not found)
        return None
