require 'rugged'

module Git
  class << self
    def latest_tag
      `git describe --tags`.split("-")[0].strip
    end

    # delegate to git cli
    def method_missing(method, *args, &block)
      `git #{method} #{args.join(" ")}`
    end
  end
end
