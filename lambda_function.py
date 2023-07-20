import json
import boto3
import datetime
import os




def lambda_handler(event, context):
    # DynamoDB table name
    table_name = 'user-table-01'
    bucket_name = 'bucket-01'
    
    # Extract user information from the event
    claims = event['requestContext']['authorizer']['claims']
    
    # Retrieve the name and email attributes from the claims
    name = claims.get('name')
    email = claims.get('email')
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Prepare the file content
    file_content = f"Hello {name}, the current time is: {timestamp}"
    
    # Check if the attributes are present in the claims
    if name and email:
        # User attributes found, perform further processing
        
        
        # Write user information to DynamoDB
        dynamodb_resource = boto3.resource("dynamodb")
        table = dynamodb_resource.Table(table_name)
        #inserting values into table
        response = table.put_item(
        Item={
                "username": name,
                "timestamp": timestamp,
            }
        )


        # Upload the file to the S3 bucket
        s3_client = boto3.client('s3')
        bucket_name = bucket_name
        new_name = name.replace(" ", "_")
        file_name = f"{new_name}.txt"
        #s3_client.put_object(Bucket=bucket_name, Key=file_name, Body=file_content)
    

        return {
            'statusCode': 200,
            'body': json.dumps(response, indent=2) + 'Success db updated' + json.dumps({'name': name, 'email': email, 'timestamp': timestamp, 'file_name': file_name})
        }
    
    else:
        # User attributes not found, handle the error
        return {
            'statusCode': 400,
            'body': 'Name and email attributes not found in claims'
        }
