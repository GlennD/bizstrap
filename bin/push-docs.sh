#!/bin/sh

S3_PATH=bizstrap/docs/tip
S3_HOST=com-bizo-public.s3-website-us-east-1.amazonaws.com

echo "Building Your Docs With Jekyll..."
cd jekyll_docs && jekyll

echo "Uploading Docs to S3"
s3cp --headers 'x-amz-acl: public-read' -r _site/ s3://com-bizo-public/$S3_PATH 

echo "Done! View the docs at: http://$S3_HOST/$S3_PATH/pages/index.html"

