import json
import pymysql
import os
import urllib.parse

# RDS configuration (use environment variables in Lambda)
RDS_HOST = os.environ['RDS_HOST']
RDS_USER = os.environ['RDS_USER']
RDS_PASSWORD = os.environ['RDS_PASSWORD']
RDS_DB = os.environ['RDS_DB']

def lambda_handler(event, context):

    try:
        # Get S3 event details
        bucket_name = event['Records'][0]['s3']['bucket']['name']
        object_key = urllib.parse.unquote_plus(
            event['Records'][0]['s3']['object']['key']
        )
        file_size = event['Records'][0]['s3']['object']['size']

        file_type = object_key.split('.')[-1]

        # Connect to RDS
        connection = pymysql.connect(
            host=RDS_HOST,
            user=RDS_USER,
            password=RDS_PASSWORD,
            database=RDS_DB
        )

        with connection.cursor() as cursor:
            sql = """
            INSERT INTO file_validation_log
            (file_name, file_size, file_type, validation_status)
            VALUES (%s, %s, %s, %s)
            """

            cursor.execute(sql, (
                object_key,
                file_size,
                file_type,
                "UPLOADED_TO_S3"
            ))

        connection.commit()
        connection.close()

        return {
            'statusCode': 200,
            'body': json.dumps('File metadata inserted successfully')
        }

    except Exception as e:
        print("Error:", str(e))
        return {
            'statusCode': 500,
            'body': json.dumps('Error processing file')
        }
