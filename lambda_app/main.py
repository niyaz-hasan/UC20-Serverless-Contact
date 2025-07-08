import os
import json
import boto3
from datetime import datetime
from uuid import uuid4

dynamodb = boto3.resource('dynamodb')
ses = boto3.client('ses')

TABLE_NAME = os.environ['TABLE_NAME']
EMAIL_RECIPIENT = os.environ['EMAIL_RECIPIENT']

def lambda_handler(event, context):
    body = json.loads(event.get("body", "{}"))
    name = body.get("name")
    email = body.get("email")
    message = body.get("message")

    if not name or not email or not message:
        return {"statusCode": 400, "body": json.dumps({"error": "Missing fields"})}

    # Store in DynamoDB
    table = dynamodb.Table(TABLE_NAME)
    contact_id = str(uuid4())
    timestamp = datetime.utcnow().isoformat()
    table.put_item(Item={
        "id": contact_id,
        "name": name,
        "email": email,
        "message": message,
        "timestamp": timestamp,
    })

    # Send notification via SES
    ses.send_email(
        Source=EMAIL_RECIPIENT,
        Destination={"ToAddresses": [EMAIL_RECIPIENT]},
        Message={
            "Subject": {"Data": "New Contact Form Submission"},
            "Body": {
                "Text": {
                    "Data": f"Name: {name}\nEmail: {email}\nMessage:\n{message}"
                }
            },
        }
    )

    return {"statusCode": 200, "body": json.dumps({"message": "Submitted successfully"})}
