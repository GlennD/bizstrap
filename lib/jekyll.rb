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
      FileUtils.mv config_path, "#{config_path}.tmp" 
      File.open(config_path, 'w') do |f|
        f.write File.read(prod_config_path).gsub("VERSION", version)
      end

      out_dir    = Dir.mktmpdir("jekyll")
      Jekyll.build source_dir, out_dir 
      FileUtils.mv "#{config_path}.tmp", config_path 
      
      out_dir
    end
  end
end
