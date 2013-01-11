require 'tmpdir'

module Jekyll
  class << self
    def build(source_dir, out_dir) 
      `jekyll #{source_dir} #{out_dir}`
    end

    def start_server(source_dir)
      `jekyll #{source_dir} --server --auto`
    end
  end
end
