module Git
  class << self
    def latest_tag
      `git tag`.split("\n")[-1].strip
    end

    def create_tag(name)
      `git tag -a #{name} -m #{name}`
    end
  end
end
