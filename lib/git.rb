require 'rugged'

module Git
  class << self
    def latest_tag
      `git describe --tags`.split("-")[0].strip
    end

    def create_tag(name)
      `git tag -a #{name} -m #{name}`
    end
  end
end
