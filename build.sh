echo "Compiling Bootstrap files to ${1}"
lessc ./less/bootstrap.less > $1 -x
echo "Done!"
