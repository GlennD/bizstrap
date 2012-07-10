[Bizsrtap](http://code.bizo.com/bizstrap)
=================

Quick start
-----------

Copy the starter code from http://code.bizo.com/bizstrap and off you go!


Contributing 
-----------

You'll need: 

- lessc: Follow the instructions here for installing via npm http://lesscss.org/
- ruby: macs come with ruby by default which is sufficient, ubuntu/debian users can apt-get install it. 
- AWS (Amazon) keys setup for deployment to S3

Building
-----------

ruby bin/build.rb <output> OR ruby bin/build.rb <output> -w to automatically rebuild when files change 
Ex. ruby bin/build.rb bizstrap.css


Deployment
-----------
Deployment is based off of the latest git tag, eg. 2.0.3.1, you can compile & deploy bizstrap to the Cloudfront CDN by running:
./deploy.sh

(assuming you have the proper S3 keys/permissions) 

Versioning
----------
Bizstrap follows the Boostrap release convention, only we append an additional version number: eg. bizstrap.2.0.3.x.css


