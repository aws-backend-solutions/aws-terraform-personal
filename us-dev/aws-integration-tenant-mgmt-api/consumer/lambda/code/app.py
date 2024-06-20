import json
import requests
import os

def lambda_handler(event, context):
    private_api_url = "https://"+os.environ['api_id']+".execute-api."+os.environ['aws_region']+".amazonaws.com/"+os.environ['stage_name']+"/"+os.environ['path_part']
    payload = event['body']

    try:
        response = requests.post(private_api_url, json=payload)
        
        return {
            "statusCode": response.status_code,
            "body": response.text,
            "headers": dict(response.headers)
        }
    except requests.exceptions.RequestException as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": str(e)}),
        }