git checkout bizo -- docs/bizo
cp -R docs/bizo/* . 
rm -rf docs
echo "Ready for deploy to github, commit changes then run git push origin gh-pages "
