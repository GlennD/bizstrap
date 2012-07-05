#!/usr/bin/env ruby
### 
#  This script geneartes a css stub file for all the classes in the <input> file.
#  The stub file contains blank css rules for every css class declaration detected.
#  This makes it easy to place stub files into GWT projects
#  
#  Example:
# input.css.... 
# .foo { margin: 0 auto; }
# output.css ... 
# .foo {}
###
require 'set'


if ARGV.length < 2
  puts "Usage: <input css file> <output stub file>"
  puts "E.g.: ruby generate_css_stubfile.rb docs/assets/css/bootstrap.css stub.css"
end

input  = ARGV[0]
output = ARGV[1]

regex =  /\.([a-zA-Z0-9\-\.\s\,]+)\s*\{/
css_classes = Set.new

File.open(ARGV[0], "r") do |f|
  f.each do |line|
    if line =~ regex
      classes = line.match(regex)[1]

      # take care of rules like .foo.boo,.mooo .shu {}
      classes.split(",").each do |class_list|
        class_list.split(" ").each do |class_group|
          class_group.split(".").each do |class_name|
            css_classes << class_name  if class_name.length > 1
          end
        end
      end
    end
  end
end


STUB_HEADER = <<STUB_HEADER
/*
 This is not the full bizstrap file, but only aliases of the CSS class names we actually use in BMP.

 Due to CSS3 rules in bizstrap.css, which the GWT/flute parser doesn't support,
 we couldn't copy/paste all of bizstrap.css into BMP as a regular GWT css file.

 However, we still want to use style().foo() references in the GWT app.

 By lazily declaring the classes we use here, and marking the entire file external,
 the GWT code should be able to reference the CSS class names that are actually
 pulled in via a stylesheet link in app.html.
 */

 @external *;
STUB_HEADER

File.open(output, 'w') do |f|
  f << STUB_HEADER + "\n"

  css_classes.sort { |a,b| a <=> b }.each do |class_name|
    f << ".#{class_name} {}\n"
  end
end



