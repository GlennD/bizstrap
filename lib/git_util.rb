require 'rugged'

module Git
  class << self
    def latest_tag()
      `git describe --tags | cut -d '-' -f1,2`.strip
    end

    def create_tag(name, message) 
      # directly call to git for now since rugged
      # is annoying to make tags with
      `git tag -a #{name} -m #{message}`
    end

    def write_diff_since_last_tag(output)
      `git diff #{Git.latest_tag} HEAD > #{output}`
    end
  end
end
