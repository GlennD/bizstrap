require 'rubygems'
require 'fileutils'
require 'colorize'
require './lib/file_watcher'
require './lib/css_stub_generator'
require './lib/git'
require './lib/s3'
require './lib/jekyll'

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
task :deploy => [:compile, :tick_tag_version, :compile_stub,  :deploy_to_s3] do |t|
  puts "make sure to 'rake update_gh_pages' to sync the github documentation".yellow
end

# Deploy #{JEKYLL_BIZSTRAP_FILE} to s3, no desc line to keep it "private"
task :deploy_to_s3 do |t|
  tag      = Git.latest_tag
  bucket   = "com-bizo-public"
  css_path = "bizstrap/css/bizstrap-#{tag}.css"
  S3.upload JEKYLL_BIZSTRAP_FILE, bucket, css_path, "text/css"

  puts ""
  puts "bizstrap-#{tag} deployed:"  
  puts "-------------------------------"
  puts "http://media.bizo.com/bizstrap/css/#{File.basename(css_path)}".green
  puts "HTTPS use https://d357yvvzeewyka.cloudfront.net/bizstrap/css/#{File.basename(css_path)}".green
end

# Create a new tag, one version higher than the last eg 2.2.2 => 2.2.3
task :tick_tag_version do |t|
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
task :deploy_docs do |t|
  source_dir           = File.join(".", "jekyll_docs")
  jekyll_config        = File.join source_dir, "_config.yml"
  jekyll_config_local  = File.join source_dir, "_config.local.yml"
  jekyll_config_prod   = File.join source_dir, "_config.prod.yml"


  # Flip to using the "prod" config which uses the production bizstrap css file vs the local repo one
  # jekyll will then generate the static site with the "real" bizstrap-version.css file
  FileUtils.mv  jekyll_config, jekyll_config_local

  latest_tag = Git.latest_tag

  File.open(jekyll_config, 'w') do |f|
    f.write File.read(jekyll_config_prod).gsub("VERSION", latest_tag)
  end

  out_dir    = Dir.mktmpdir("jekyll")
  Jekyll.build source_dir, out_dir 

  # put the local config back after we're done
  FileUtils.mv  jekyll_config_local, jekyll_config

  bucket    = "com-bizo-public"
  docs_path = "bizstrap/docs/#{latest_tag.gsub('.', '-')}"
  puts "Uploading docs to s3".green

  S3.upload_dir out_dir, bucket, docs_path
  puts "Uploading of docs to s3 complete: http://media.bizo.com/bizstrap/docs/#{latest_tag}".green
end


desc "Start Jekyll server with automatic updates when files change"
task :jekyll do |t, args|
  Jekyll.start_server File.join(".", "jekyll_docs")
end



