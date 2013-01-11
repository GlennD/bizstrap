require 'rubygems'
require 'fileutils'
require 'colorize'
require './lib/file_watcher'
require './lib/css_stub_generator'
require './lib/git'
require './lib/s3'
require './lib/jekyll'

SOURCE                 = File.join ".", "less", "bootstrap.less"
JEKYLL_BIZSTRAP_FILE   = File.join ".", "jekyll_docs", "assets", "css", "bootstrap.css"
S3_BUCKET              = "com-bizo-public"

desc "Compile less files to jekyll_docs/assets/css/bootstrap.css, rake compile[watch] to compile when files change"
task :compile, :compile_mode do |t, args|
  mode = (args[:compile_mode] || :single).to_sym

  source = SOURCE 
  output = JEKYLL_BIZSTRAP_FILE

  build = Proc.new do
    puts "compiling .less files to #{output}"
    p `lessc #{source} #{output}`
  end

  build.call

  if mode == :watch
    puts "watching for additional changes control-c to kill me".yellow
    FileWatcher.new(:load_path => "./less", :glob_str => "**/*.less") do 
      build.call
    end
  end

end


desc "Generate css stub file for usage in GWT"
task :compile_stub do |t|
  latest_tag = Git.latest_tag
  stubfile = "bizstrap-stub-#{latest_tag}.css"
  output = File.join ".", stubfile
  CssStubGenerator.new(JEKYLL_BIZSTRAP_FILE).write(output)
  puts "created css stubfile for GWT: #{stubfile}"
end

desc "Deploys bizstrap + versioned docs to s3 under a new git tag, runs compile & compile_stub first"
task :deploy => [:compile, :tick_tag_version, :compile_stub,  :deploy_to_s3, :deploy_docs] do |t|
  puts "make sure to 'git push --tags' to push your new tag to github".yellow
end

# Deploy #{JEKYLL_BIZSTRAP_FILE} to s3, no desc line to keep it "private"
task :deploy_to_s3 do |t|
  tag      = Git.latest_tag
  css_path = "bizstrap/css/bizstrap-#{tag}.css"
  S3.upload JEKYLL_BIZSTRAP_FILE, S3_BUCKET, css_path, "text/css"

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
  file_location = File.join(".", "jekyll_docs", "pages", "index.html")

  # update the tag in the stater code
  text = File.read(file_location)
  text.gsub!(/http:\/\/media.bizo.com\/bizstrap\/css\/bizstrap-v([^\s]+).css/, "http://media.bizo.com/bizstrap/css/bizstrap-#{latest_tag}.css")

  File.open(file_location, 'w') { |f| f.write(text) }

  puts "updated starter code in jekyll_docs to: bizstrap-#{latest_tag}.css"
end

# sets up redirect 
# media.bizo.com/bizstrap/docs/current/index.html =>
# media.bizo.com/bizstrap/docs/#{latest_version}/pages/index.html
task :tick_docs_current_pointer do |t|
  web_tag   = Git.latest_tag.gsub('.', '-')
  latest_bizstrap = "http://media.bizo.com/bizstrap/docs/#{web_tag}/pages/index.html" 
  html_file = File.join(Dir.tmpdir, "index.html")

  File.open(html_file, 'w') do |f|
    f.write <<-HTML
    <html>
      <head>
        <meta http-equiv="Refresh" content="0; url=#{latest_bizstrap}" />
      </head>
      <body>
        <p>Latest Bizstrap is: <a href="#{latest_bizstrap}">this link</a>.</p>
      </body>
    </html>
    HTML
  end

  S3.upload html_file, S3_BUCKET, "bizstrap/docs/current/index.html", "text/html"
end


# Uploads a versioned set of docs to s3, where the version == Git.latest_tag
task :deploy_docs => :update_docs do |t|
  source_dir           = File.join ".", "jekyll_docs"
  jekyll_config        = File.join source_dir, "_config.yml"
  jekyll_config_local  = File.join source_dir, "_config.local.yml"
  jekyll_config_prod   = File.join source_dir, "_config.prod.yml"

  latest_tag = Git.latest_tag

  # Flip to using the "prod" config which uses the production bizstrap css file vs the local repo one
  # jekyll will then generate the static site with the "real" bizstrap-version.css file
  out_dir = Jekyll.build_with_prod_config(
              source_dir, 
              jekyll_config, 
              jekyll_config_prod, 
              latest_tag
            )

  web_tag   = latest_tag.gsub('.', '-')
  docs_path = "bizstrap/docs/#{web_tag}"
  puts "Uploading docs to s3".green

  S3.upload_dir out_dir, S3_BUCKET, docs_path
  puts "Uploading of docs to s3 complete: ".green
end


desc "Start Jekyll server with automatic updates when files change"
task :server do |t, args|
  Jekyll.start_server File.join(".", "jekyll_docs")
end



