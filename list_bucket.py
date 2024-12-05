from flask import Flask, jsonify
import boto3
from botocore.exceptions import NoCredentialsError, ClientError
import logging
from logging.handlers import RotatingFileHandler

app = Flask(__name__)

s3_client = boto3.client('s3')

BUCKET_NAME = 'one2n-test1'

access_handler = RotatingFileHandler('access.log', maxBytes=10000, backupCount=3)
error_handler = RotatingFileHandler('error.log', maxBytes=10000, backupCount=3)

access_handler.setLevel(logging.INFO)  # Log general information
error_handler.setLevel(logging.ERROR)  # Log only errors

formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
access_handler.setFormatter(formatter)
error_handler.setFormatter(formatter)

app.logger.addHandler(access_handler)
app.logger.addHandler(error_handler)

@app.route('/list-bucket-content/', defaults={'path': ''}, methods=['GET'])
@app.route('/list-bucket-content/<path:path>', methods=['GET'])
def list_bucket_content(path):
    app.logger.info(f"Request received for path: {path}")
    try:
        path = path.rstrip('/')

        if path == '':
            result = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Delimiter='/')
        else:
            result = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=path + '/', Delimiter='/')

        if 'Contents' not in result and 'CommonPrefixes' not in result:
            app.logger.warning(f"Path does not exist: {path}")
            return jsonify({"error": "Path does not exist"}), 404

        content_list = []

        if 'CommonPrefixes' in result:
            content_list.extend([obj['Prefix'].rstrip('/').split('/')[-1] for obj in result['CommonPrefixes']])

        if 'Contents' in result:
            content_list.extend([obj['Key'].split('/')[-1] for obj in result['Contents'] if obj['Key'] != path + '/'])

        app.logger.info(f"Successfully listed content for path: {path}")
        return jsonify({"content": sorted(content_list)})

    except NoCredentialsError:
        app.logger.error("Invalid AWS credentials")
        return jsonify({"error": "Invalid AWS credentials"}), 401
    except ClientError as e:
        app.logger.error(f"Client error: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

