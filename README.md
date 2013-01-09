[Bizstrap](http://code.bizo.com/bizstrap)
=================

Quick start
-----------

Copy the starter code from http://code.bizo.com/bizstrap and off you go!

Contributing 
-----------

You'll need: 

- lessc: Follow the instructions here for installing via npm http://lesscss.org/
- ruby: macs come with ruby by default which is sufficient, ubuntu/debian users can apt-get install it. 
- Bundler: gem install bundler (might need to use sudo depending on your ruby setup)
- Jekyll (optional: documentation website only): gem install jekyll
- AWS (Amazon) keys setup for deployment to S3


Setup
-----------
run bundle install to grab the gems needed to build bizstrap (you only need to do this once)

Building
-----------
To compile bizstrap:

rake compile

OR

rake compile[watch] to re-compile as .less files change

Deployment
-----------
Deployment is based off of the latest git tag, eg. 2.0.3.1, you can compile & deploy bizstrap to the Cloudfront CDN by running:

rake deploy

This will automatically create a new git tag for you, eg. if the current tag is v2.2.2.2 then rake deploywill deploy bizstrap-v2.2.2.3

(assuming you have the proper S3 keys/permissions) 

Documentation
-----------
Bizstrap's docs are generated using jekyll (gem install jekyll). To run the documentation site locally:

cd jekyll_docs && jekyll --server --auto

The documentation site is hosted under git-hub via the gh-pages branch. Make sure you keep this up to date by running 

rake update_gh_pages

This will sync the jekyll_docs directory in the bizo branch to github

Versioning
----------
Bizstrap follows the Boostrap release convention, only we append an additional version number: eg. bizstrap.2.0.3.x.css
