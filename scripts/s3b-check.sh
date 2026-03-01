#!/bin/bash

# Set the AWS region and the name of the S3 bucket
REGION="us-east-1"
BUCKET="my-s3-bucket"

# Set the name of the file to copy
FILE="my-file.txt"

# Check if the S3 bucket exists
if aws s3 ls "s3://$BUCKET" --region "$REGION" &> /dev/null; then
  # If the bucket exists, list the objects in the bucket
  echo "The bucket '$BUCKET' exists. Here are the objects in the bucket:"
  aws s3 ls "s3://$BUCKET" --region "$REGION"

  # Copy the file to the S3 bucket
  echo "Copying the file '$FILE' to the bucket '$BUCKET'..."
  aws s3 cp "$FILE" "s3://$BUCKET" --region "$REGION"
else
  # If the bucket does not exist, print an error message
  echo "The bucket '$BUCKET' does not exist."
fi
