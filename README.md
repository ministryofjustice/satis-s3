# satis-s3

A docker image to build a composer repository using [satis](https://github.com/composer/satis), and upload it to an AWS S3 bucket.

This image extends [iainmckay/satis-s3](https://github.com/iainmckay/satis-s3).

## Configuration 

The script requires the following environment variables:

Name | Description | Required
---- | ----------- | --------
`AWS_ACCESS_KEY_ID` | Your AWS access key | Required
`AWS_SECRET_ACCESS_KEY` | Your AWS secret access key | Required
`AWS_DEFAULT_REGION` | The AWS region the bucket is in | Required
`GITHUB_AUTH` | [Personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) for access to GitHub. Use this to avoid hitting GitHub API rate limits. | Optional
`S3_BUCKET` | The bucket to write the artifacts to | Required
`S3_PATH` | The path inside the bucket to write the artifacts to | Optional
