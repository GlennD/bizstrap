require 'rubygems'
require 'colorize'
require './lib/file_watcher'
require './lib/css_stub'
require './lib/git_util'
require './lib/s3'

BASE_DIR = File.dirname(__FILE__)
SOURCE = File.join(BASE_DIR, "less", "bootstrap.less")
OUTPUT = File.join(BASE_DIR, "jekyll_docs", "assets", "css", "bootstrap.css")

desc "Compile less files to jekyll_docs/assets/css/bootstrap.css, rake compile[watch] to compile when files change"
task :compile, :compile_mode do |t, args|
  mode = (args[:compile_mode] || :single).to_sym

  source = SOURCE 
  output = OUTPUT

  build = Proc.new do
    puts "Compiling Bootstrap files to #{output}".green
    p `lessc #{source} #{output}`
  end

  build.call

  if mode == :watch
    puts "Watching for additional changes control-c to kill me".yellow
    FileWatcher.new(:load_path => "./less", :glob_str => "**/*.less") do 
      build.call
    end
  end
end


desc "Generate css stub file for usage in GWT"
task :compile_stub do |t|
  input = OUTPUT 
  output = File.join(BASE_DIR, "css-stub.css")

  stub_generator = CssStubGenerator.new(input)
  stub_generator.write(output)
  puts "Css stub file for GWT created at: ./css-stub.css".green
end

# Generate a diff file between the most recent tag & HEAD, for code reviews
task :create_diff do |t|
  Git.write_diff_since_last_tag("code-review.diff")
  puts "Generated diff for code review, upload ./code_review.diff to http://bizodev.jira.com"
end

# Update the starter code documentation to use the latest bizstrap version
task :update_docs do |t|
  latest_tag = Git.latest_tag

  file_location = File.join(BASE_DIR, "jekyll_docs", "pages", "index.html")

  # update the tag in the stater code
  text = File.read(file_location)
  text.gsub!(/http:\/\/media.bizo.com\/bizstrap\/css\/bizstrap-v([^\s]+).css/, "http://media.bizo.com/bizstrap/css/bizstrap-#{latest_tag}.css")

  File.open(file_location, 'w') { |f| f.write(text) }
  puts "Updated starter code in jekyll_docs to: bizstrap-#{latest_tag}.css".green
end


# Create a new tag, one version higher than the last eg 2.2.2 => 2.2.3
task :tick_tag_version do |t, args|

  # next available tag version, eg. v2.2 => v2.3
  parts = Git.latest_tag.split(".")
  parts[-1] = (parts[-1].to_i + 1).to_s
  next_tag = parts.join(".")

  # don't need a message, git log v2.2.1..2.2.2 is more useful anyways 
  Git.create_tag next_tag, next_tag 
  puts "Created git tag: #{next_tag}".green
end

# Deploy #{OUTPUT} to s3, no desc line to keep it "private"
task :deploy_to_s3 do |t|
  tag      = Git.latest_tag
  bucket   = "com-bizo-public"
  css_path = "bizstrap/css/bootstrap-#{tag}.css"
  S3.upload OUTPUT, bucket, css_path, "text/css"

  puts "Bizstrap #{tag} successfully deployed: http://media.bizo.com/bizstrap/css/#{File.basename(css_path)}".green
  puts "HTTPS use https://d357yvvzeewyka.cloudfront.net/bizstrap/css/#{File.basename(css_path)}".green
end

desc "One stop task that does everything to deploy bizstrap, including compilation"
task :deploy => [:compile, :compile_stub, :update_docs, :create_diff, :tick_tag_version, :deploy_to_s3] do |t|
end
