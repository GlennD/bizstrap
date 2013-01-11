[Bizstrap](http://code.bizo.com/bizstrap)
=================

Usage
-----------

See documentation at: http://code.bizo.com/bizstrap

Setting Up Your System to Contribute
-----------

Make sure you have ruby installed (you're systems default should suffice)

1. Install npm, easiest way is via installing node.js (http://nodejs.org/download/)
2. npm install -g less
3. gem install bundler
4. bundle install,  from the bizstrap project root
5. gem install jekyll, depending on your ruby setup, you might have to sudo gem install jekyll 
6. AWS (Amazon) keys setup, so you can deploy to S3 


What's with node.js?! Currently the lessc package in npm is the most maintained, the best way to get npm on your system is through node. 

Building
-----------

Let's say you want to make some changes to Bizstrap. Here's the reccommended workflow: 


1. Fire up your terminal & run: rake compile[watch], this will compile the less files whenever they change to css for you
2. In another termainal: rake server, this will mount the bizstrap doc site at http://localhost:4000/pages/index.html
3. Make some changes to the .less files & review the effects on your local docs site 
4. Commit your changes locally. 
5. Code review time! git diff HEAD^ HEAD > code_review.diff + upload to JIRA
6. Asumming everything is a-ok in the review move on to deploying...

Deployment
-----------

You can deploy a new version of Bizstrap + corresponding set of versioned docs with a single command:

    rake deploy

Assuming the last Bizstrap version was v2.2.2.2, this would do the following:

- compile the .less files to jekyll_docs/assets/css
- create a new git tag, one version higher than the last, eg. v2.2.2.2 => v2.2.2.3
- compile a css stub file for use with GWT versioned for v2.2.2.3 
- deploy the compiled css to s3 using the new tag, eg. bizstrap-v2.2.2.3.css
- update the docs reference bizstrap-v2.2.2.3
- upload the updated docs to s3 under the tag version, eg /docs/bizstrap-v2-2-2-3/
- update a redirect file in S3 such that /docs/current => /docs/bizstrap-v2-2-2-3/

If you mess up a deployment, that's ok, simply do the following: 

    git tag -d <messed-up-version>

Do what you need to do to fix whatever you messed up, then 

    rake deploy


Which will (re)deploy under the same new tag


When you're really sure the next release is ready go 

git push origin bizo # push the new code to github
git push --tags # push your new tag up to github

Versioning
----------
Bizstrap follows the Boostrap release convention, only we append an additional version number: eg. bizstrap.2.0.3.x.css
