import json
import requests
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    print(event)

    aws_region = None
    if 'us-' in os.environ['path_part']:
        aws_region = "us-west-2"
    elif 'eu-' in os.environ['path_part']:
        aws_region = "eu-central-1"
    else:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Invalid path_part provided during the configuration."}),
        }

    private_api_url = "https://"+os.environ['api_id']+".execute-api."+aws_region+".amazonaws.com/"+os.environ['stage_name']+"/tenants"
    logger.info(f"Private API URL: {private_api_url}")

    payload = event['body']
    payload = json.loads(payload)
    logger.info(f"Payload: {payload}")

    try:
        response = requests.post(private_api_url, json=payload)
        logger.info(f"Successful response: {response}")
        
        return {
            "statusCode": response.status_code,
            "body": response.text,
            "headers": dict(response.headers)
        }
    except requests.exceptions.RequestException as e:
        logger.error(f"Error response: {e}")
        
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
