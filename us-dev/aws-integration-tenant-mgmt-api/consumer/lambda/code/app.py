import json
import requests
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    print(event)

    try:
        body = event.get('body', '{}')
        payload = json.loads(body)
        source_env = payload.get('source_env')
        stage_name = os.environ['stage_name']

        if not source_env:
            return create_response(400, {"errors": ["'source_env' is a mandatory field."]})

        api_url, api_id = get_api_details(source_env)

        if not api_url or not api_id:
            return create_response(400, {"errors": ["'source_env' is invalid."]})

        logger.info(f"Private API URL: {api_url}")

        headers = {
            "Content-Type": "application/json",
            "x-apigw-api-id": api_id
        }

        response = requests.post(f"https://{api_url}/{stage_name}/tenants", json=payload, headers=headers)
        logger.info(f"Successful response: {response.status_code}")

        return create_response(response.status_code, json.loads(response.text))

    except requests.exceptions.RequestException as e:
        logger.error(f"RequestException: {e}")
        return create_response(500, {"errors": [str(e)]})

    except ValueError as e:
        logger.error(f"ValueError: {e}")
        return create_response(400, {"errors": [str(e)]})

    except Exception as e:
        logger.error(f"Exception: {e}")
        return create_response(500, {"errors": [str(e)]})

def get_api_details(source_env):
    if source_env == os.environ.get('us_staging_domain'):
        return os.environ.get('us_staging_vpce'), os.environ.get('us_staging_api_id')
    elif source_env == os.environ.get('eu_staging_domain'):
        return os.environ.get('eu_staging_vpce'), os.environ.get('eu_staging_api_id')
    else:
        return None, None

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