module GemEmpty
  # monkey patch rubygems specification to easily find gem version
  module Specification
    def self.installed_gems
      if Gem::VERSION > '1.8'
        Gem::Specification.to_a
      else
        Gem.source_index.map{|name,spec| spec}
      end
    end
    def self.find_gem_spec(name)
      installed_gems.find{|spec| spec.name == name}
    end
    def self.gem_loaded?(name, version)
      spec = find_gem_spec(name)
      spec && spec.version.to_s == version
    end
  end
end
