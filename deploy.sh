TAG=`git describe | cut -d '-' -f1`
BIZSTRAP=bizstrap-$TAG.css
RELEASE_PATH=s3://com-bizo-public/bizstrap/$BIZSTRAP

./build.sh $BIZSTRAP 

echo "Uploading to s3..."
s3cp $BIZSTRAP $RELEASE_PATH 
s3mod $RELEASE_PATH public-read

echo "Cleaning Up..."
rm $BIZSTRAP

echo "Done: Bizstrap is available at: http://media.bizo.com/bizstrap/${BIZSTRAP}"
