FROM iainmckay/satis-s3

# Overwrite existing run.sh with our own version.
# Our version additionally configures GitHub auth for composer to avoid API usage limits,
# and uses different command line options for syncing files to S3.
ADD run.sh /run.sh
