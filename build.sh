echo "Compiling Bootstrap files to bootstrap.css"
lessc ./less/bootstrap.less > bootstrap.css --compress
echo "Done!"
