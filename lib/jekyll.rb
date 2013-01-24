require 'tmpdir'
require 'fileutils'

module Jekyll
  class << self
    def build(source_dir, out_dir) 
      `jekyll #{source_dir} #{out_dir}`
    end

    def start_server(source_dir)
      `jekyll #{source_dir} #{Dir.mktmpdir} --server --auto`
    end

    def build_with_prod_config(source_dir, config_path, prod_config_path, version)
      # you can't tell jekyll which _config.yml to use
      # hence swap in the prod config & put the local one back when it's done.
      FileUtils.mv config_path, "#{config_path}.tmp" 
      File.open(config_path, 'w') do |f|
        text = File.read(prod_config_path)
        f.write text.gsub("HYPHENATED-VERSION", version.gsub(".", "-")).gsub("VERSION", version)
      end

      out_dir    = Dir.mktmpdir("jekyll")
      Jekyll.build source_dir, out_dir 
      FileUtils.mv "#{config_path}.tmp", config_path 
      
      out_dir
    end
  end
end
