TAG=`git describe --tags | cut -d '-' -f1,2`
BIZSTRAP=bizstrap-$TAG.css
BASE_PATH=s3://com-bizo-public/bizstrap
CSS_RELEASE_PATH=$BASE_PATH/css/$BIZSTRAP
IMG_RELEASE_PATH=$BASE_PATH/img
JS_RELEASE_PATH=$BASE_PATH/js

./bin/build.rb $BIZSTRAP


echo "Updating Docs..."
./bin/update_docs.rb

echo "Uploading CSS to s3..."
s3cp $BIZSTRAP $CSS_RELEASE_PATH 
s3mod $CSS_RELEASE_PATH public-read

echo "Uploading images to s3..."
s3cp img $BASE_PATH -r
s3mod $IMG_RELEASE_PATH/logo.png public-read
s3mod $IMG_RELEASE_PATH/glyphicons-halflings-white.png public-read
s3mod $IMG_RELEASE_PATH/glyphicons-halflings-grey.png public-read
s3mod $IMG_RELEASE_PATH/glyphicons-halflings.png public-read

echo "Cleaning Up..."
rm $BIZSTRAP

echo "Done: Bizstrap is available at: http://media.bizo.com/bizstrap/css/${BIZSTRAP}"
