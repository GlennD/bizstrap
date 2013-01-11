require 'rugged'

module Git
  class << self
    def latest_tag
      `git describe --tags`.split("-")[0].strip
    end
  end
end
