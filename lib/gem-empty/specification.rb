module GemEmpty
  module Specification
    def self.find(name = "gem-empty")
      @gem_empty_spec ||=
        if Gem::Specification.respond_to?(:find_by_name)
          Gem::Specification.find_by_name(name)
        else
          Gem.source_index.find_name(name).last
        end
    rescue Gem::LoadError
      nil
    end
    def self.version
      find ? find.version.to_s : nil
    end
  end
end
