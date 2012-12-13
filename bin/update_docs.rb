#!/usr/bin/env ruby

latest_tag = `git describe --tags | cut -d '-' -f1,2`.strip

file_location = File.join("jekyll_docs", "pages", "index.html")
text = File.read(file_location)
text.gsub!(/http:\/\/media.bizo.com\/bizstrap\/css\/bizstrap-v([^\s]+).css/, "http://media.bizo.com/bizstrap/css/bizstrap-#{latest_tag}.css")

puts "Updated docs to: #{latest_tag}"
File.open(file_location, 'w') { |f| f.write(text) }


