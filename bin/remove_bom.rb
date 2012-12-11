
files = Dir.glob(File.join(".", ARGV[0], "**/*.less"))
files.each do |file|
  puts "awk '{if(NR==1)sub(/^\xef\xbb\xbf/,\"\");print}' #{file} > #{file} \n"
end
