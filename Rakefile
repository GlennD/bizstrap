require 'rubygems'
require 'fileutils'
require 'colorize'
require './lib/file_watcher'
require './lib/css_stub_generator'
require './lib/git'
require './lib/s3'

BASE_DIR               = File.dirname __FILE__
SOURCE                 = File.join BASE_DIR, "less", "bootstrap.less"
JEKYLL_BIZSTRAP_FILE   = File.join BASE_DIR, "jekyll_docs", "assets", "css", "bootstrap.css"

desc "Compile less files to jekyll_docs/assets/css/bootstrap.css, rake compile[watch] to compile when files change"
task :compile, :compile_mode do |t, args|
  mode = (args[:compile_mode] || :single).to_sym

  source = SOURCE 
  output = JEKYLL_BIZSTRAP_FILE

  build = Proc.new do
    puts "compiling .less files to #{output}"
    p `lessc #{source} #{output}`
  end

  if mode == :watch
    puts "watching for additional changes control-c to kill me".yellow
    FileWatcher.new(:load_path => "./less", :glob_str => "**/*.less") do 
      build.call
    end
  end

  build.call
end


desc "Generate css stub file for usage in GWT"
task :compile_stub do |t|
  latest_tag = Git.latest_tag
  stubfile = "bizstrap-stub-#{latest_tag}.css"
  output = File.join BASE_DIR, stubfile
  CssStubGenerator.new(JEKYLL_BIZSTRAP_FILE).write(output)
  puts "created css stubfile for GWT: #{stubfile}"
end

desc "Deploys bizstrap to s3 under a new git tag, runs compile & compile_stub first"
task :deploy => [:compile, :compile_stub, :tick_tag_version, :deploy_to_s3] do |t|
  puts "make sure to 'rake update_gh_pages' to sync the github documentation".yellow
end

# Deploy #{JEKYLL_BIZSTRAP_FILE} to s3, no desc line to keep it "private"
task :deploy_to_s3 do |t|
  tag      = Git.latest_tag
  bucket   = "com-bizo-public"
  css_path = "bizstrap/css/bootstrap-#{tag}.css"
  S3.upload JEKYLL_BIZSTRAP_FILE, bucket, css_path, "text/css"

  puts ""
  puts "bizstrap-#{tag} deployed:"  
  puts "-------------------------------"
  puts "http://media.bizo.com/bizstrap/css/#{File.basename(css_path)}".green
  puts "HTTPS use https://d357yvvzeewyka.cloudfront.net/bizstrap/css/#{File.basename(css_path)}".green
end

# Create a new tag, one version higher than the last eg 2.2.2 => 2.2.3
task :tick_tag_version do |t, args|
  # next available tag version, eg. v2.2 => v2.3
  parts = Git.latest_tag.split(".")
  parts[-1] = (parts[-1].to_i + 1).to_s
  next_tag = parts.join(".")

  # don't need a message, git log v2.2.1..2.2.2 is more useful anyways 
  Git.tag "-a #{next_tag} -m #{next_tag}"
  puts "Created git tag: #{next_tag}"
end

# Update the starter code documentation to use the latest bizstrap version
task :update_docs do |t|
  latest_tag = Git.latest_tag
  file_location = File.join(BASE_DIR, "jekyll_docs", "pages", "index.html")

  # update the tag in the stater code
  text = File.read(file_location)
  text.gsub!(/http:\/\/media.bizo.com\/bizstrap\/css\/bizstrap-v([^\s]+).css/, "http://media.bizo.com/bizstrap/css/bizstrap-#{latest_tag}.css")

  File.open(file_location, 'w') { |f| f.write(text) }

  puts "updated starter code in jekyll_docs to: bizstrap-#{latest_tag}.css"
end

desc "Updates gh-pages branch & pushes it to github"
task :update_gh_pages do |t|
  # pull docs from bizo branch into gh-pages branch
  Git.checkout "gh-pages"
  Git.checkout "bizo -- jekyll_docs" 

  # Github wants everything in the root dir of the branch, so extract
  FileUtils.cp_r Dir.glob("jekyll_docs/*"), "."
  FileUtils.rm_rf "jekyll_docs"

  Git.add "-A"
  Git.commit "-m \"synching gh-pages docs to bizo branch\""
  Git.push "origin gh-pages"

  puts "Synched gh-pages docs to bizo branch on github".green

  # return to bizo branch
  Git.checkout "bizo" 
end


