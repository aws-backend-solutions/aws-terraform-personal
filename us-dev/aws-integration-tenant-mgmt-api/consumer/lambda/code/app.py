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
    payload = json.loads(body)
    source_env = payload['source_env']
    api_url = None
    api_id = None

    if source_env == os.environ['us_staging_domain']:
        api_url = os.environ['us_staging_vpce']
        api_id =  os.environ['us_staging_api_id']
    elif source_env == os.environ['eu_staging_domain']:
        api_url = os.environ['eu_staging_vpce']
        api_id =  os.environ['eu_staging_api_id']
    else:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid source_env value."}),
        }

    logger.info(f"Private API URL: {api_url}")

    headers = {
        "Content-Type": "application/json",
        "x-apigw-api-id": api_id
    }

    try:
        response = requests.post(f"http://{api_url}", json=payload, headers=headers)
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