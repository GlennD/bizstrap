git checkout bizo -- jekyll_docs 
cp -R jekyll_docs/* .
rm -rf jekyll_docs
git add -A
echo "Ready for deploy to github, commit changes then run git push origin gh-pages "
