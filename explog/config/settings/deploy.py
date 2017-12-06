from .base import *

config_secret = json.loads(open(CONFIG_SECRET_DEPLOY_FILE).read())

DEBUG=False
# location, storages

STATICFILES_STORAGE = 'config.storages.StaticStorage'
STATICFILES_LOCATION = 'static'

DEFAULT_FILE_STORAGE = 'config.storages.MediaStorage'
MEDIAFILES_LOCATION = 'media'

# AWS
AWS_ACCESS_KEY_ID = config_secret['aws']['access_key_id']
AWS_SECRET_ACCESS_KEY = config_secret['aws']['secret_access_key']
AWS_STORAGE_BUCKET_NAME = config_secret['aws']['s3_bucket_name']
AWS_S3_REGION_NAME = config_secret['aws']['s3_region_name']
AWS_S3_HOST = 's3.ap-northeast-2.amazonaws.com'
S3_USE_SIGV4 = True


# db
DATABASES = config_secret["django"]["databases"]

# allowed_hosts
ALLOWED_HOSTS = [
    '127.0.0.1',
    'localhost',
    '.elasticbeanstalk.com',
    '.locomoco.co.kr',
]