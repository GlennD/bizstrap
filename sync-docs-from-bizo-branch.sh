git checkout bizo -- docs/bizo
cp -R docs/bizo/* . 
rm -rf docs
git add -A
echo "Ready for deploy to github, commit changes then run git push origin gh-pages "
