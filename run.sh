#!/bin/bash
set -e

# Adapted from run.sh in iainmckay/satis-s3
# Source: https://github.com/iainmckay/satis-s3/blob/ce9d960d54aa1e6fcb888c88f6ddc1e4cd2c7c30/run.sh

# These 'env vars' are hard coded as Satis expects these locations
SATIS="/satis/bin/satis"
OUT_PATH="/tmp/satis"

if [ ! -z "$GITHUB_AUTH" ]; then
	/composer.phar config --global github-oauth.github.com "$GITHUB_AUTH"
fi

echo "ENV VARS ..."
echo "SATIS: ${SATIS}"
echo "OUT_PATH: ${OUT_PATH}"

echo "About to make OUT_PATH"
mkdir -p $OUT_PATH

# Download the existing repo from S3
echo "About to s3 sync bucket to tmp"
aws s3 sync s3://$S3_BUCKET/$S3_PATH $OUT_PATH

echo "About to rm OUT_PATH/include/*"
rm $OUT_PATH/include/*

# Rebuild the repo
echo "About to build with satis"
php $SATIS build --verbose $CONFIG_PATH $OUT_PATH

# Purge unused package files
echo "About to purge with satis"
php $SATIS purge $CONFIG_PATH $OUT_PATH

# Push it back to S3
echo "About to s3 sync tmp to bucket"
aws s3 sync --delete $OUT_PATH s3://$S3_BUCKET/$S3_PATH
