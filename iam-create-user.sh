#! /bin/bash
# Create a new iam user and create a new local aws-cli profile for that user


# Verify AWS CLI Credentials are setup
# http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
if ! grep -q aws_access_key_id ~/.aws/config; then
  if ! grep -q aws_access_key_id ~/.aws/credentials; then
    echo "AWS config not found or CLI not installed. Please run \"aws configure\"."
    exit 1
  fi
fi

read -r -p "Enter the aws username to create: " USERNAME

aws iam create-user --user-name "${USERNAME}"
credentials=$(aws iam create-access-key --user-name "${USERNAME}" \
--query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text)
access_key_id=$(echo ${credentials} | cut -d' ' -f 1)
secret_access_key=$(echo ${credentials} | cut -d' ' -f 2)
aws configure set profile.${USERNAME}.aws_access_key_id "${access_key_id}"
aws configure set profile.${USERNAME}.aws_secret_access_key "${secret_access_key}"

echo "The username ""${USERNAME}"" has been created"