import json
import requests
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    print(event)

    body = event['body']
    body_dict = json.loads(body)
    source_env = body_dict['source_env']

    print(source_env)

    # private_api_url = "https://"+os.environ['api_id']+".execute-api."+aws_region+".amazonaws.com/"+os.environ['stage_name']+"/tenants"
    # logger.info(f"Private API URL: {private_api_url}")

    # payload = event['body']
    # payload = json.loads(payload)
    # logger.info(f"Payload: {payload}")

    # try:
    #     response = requests.post(private_api_url, json=payload)
    #     logger.info(f"Successful response: {response}")
        
    #     return {
    #         "statusCode": response.status_code,
    #         "body": response.text,
    #         "headers": dict(response.headers)
    #     }
    # except requests.exceptions.RequestException as e:
    #     logger.error(f"Error response: {e}")
        
    #     return {
    #         "statusCode": 500,
    #         "body": json.dumps({"error": str(e)}),
    #     }
