#!/bin/sh

s3cp --headers 'x-amz-acl: public-read' -r jekyll_docs/_site/ s3://com-bizo-public/bizstrap/docs/tip

