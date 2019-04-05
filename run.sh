#!/bin/bash
set -e

# Adapted from run.sh in iainmckay/satis-s3
# Source: https://github.com/iainmckay/satis-s3/blob/ce9d960d54aa1e6fcb888c88f6ddc1e4cd2c7c30/run.sh

SATIS=/satis/bin/satis

if [ -z "$CONFIG_PATH" ] || [ -z "$OUT_PATH" ]; then
    >&2 echo "run.sh <path to config.json> <output path>"
    exit 1
fi

if [ ! -z "$GITHUB_AUTH" ]; then
	/composer.phar config --global github-oauth.github.com "$GITHUB_AUTH"
fi

mkdir -p $OUT_PATH

# Download the existing repo from S3
aws s3 sync s3://$S3_BUCKET/$S3_PATH $OUT_PATH
rm $OUT_PATH/include/*

# Rebuild the repo
php $SATIS build --verbose $CONFIG_PATH $OUT_PATH

# Purge unused package files
php $SATIS purge $CONFIG_PATH $OUT_PATH

# Push it back to S3
aws s3 sync --delete $OUT_PATH s3://$S3_BUCKET/$S3_PATH
