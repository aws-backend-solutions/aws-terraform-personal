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
    print("test")
    
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
