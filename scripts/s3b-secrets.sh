#!/bin/bash

# Print usage instructions if the -h option is provided
if [ "$1" == "-h" ]; then
  echo "Usage: $0 BUCKET_NAME"
  echo ""
  echo "BUCKET_NAME: the name of the S3 bucket in the format s3://my-s3-bucket"
  exit 0
fi

# Get the S3 bucket name from the command-line argument
BUCKET_NAME=$1

# Check if the S3 bucket exists
if ! aws s3 ls "$BUCKET_NAME" > /dev/null 2>&1; then
  echo "Error: The S3 bucket does not exist"
  exit 1
fi

mkdir $BUCKET_NAME
cd $BUCKET_NAME

# List all the files in the S3 bucket
aws s3 ls s3://$BUCKET_NAME > file_list.txt

# Download the files
while read p; do
  FILE_NAME=$(echo $p | cut -d' ' -f4)
  aws s3 cp s3://$BUCKET_NAME/$FILE_NAME .
done < file_list.txt

# Search the text files for ssh keys or passwords
for file in *; do
  if file $file | grep -q "text"; then
    grep -i "ssh" $file >> ssh_keys.txt
    grep -i "password" $file >> passwords.txt
  fi
done

# Count the number of files with certain extensions
PGP_COUNT=$(find . -name "*.pgp" | wc -l)
LOG_COUNT=$(find . -name "*.log" | wc -l)
ENV_COUNT=$(find . -name "*.env" | wc -l)
PY_COUNT=$(find . -name "*.py" | wc -l)
JSON_COUNT=$(find . -name "*.json" | wc -l)
PEM_COUNT=$(find . -name "*.pem" | wc -l)

# Put the results in a file called "readme.txt"
echo "SSH Keys:" > readme.txt
cat ssh_keys.txt >> readme.txt
echo "" >> readme.txt
echo "Passwords:" >> readme.txt
cat passwords.txt >> readme.txt
echo "" >> readme.txt
echo "Number of .pgp files: $PGP_COUNT" >> readme.txt
echo "Number of .log files: $LOG_COUNT" >> readme.txt
echo "Number of .env files: $ENV_COUNT" >> readme.txt
echo "Number of .py files: $PY_COUNT" >> readme.txt
echo "Number of .json files: $JSON_COUNT" >> readme.txt
echo "Number of .pem files: $PEM_COUNT" >> readme.txt

# Clean up
rm file_list.txt
rm ssh_keys.txt
rm passwords.txt
