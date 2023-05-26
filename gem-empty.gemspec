#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require File.expand_path("../lib/gem-empty/version.rb", __FILE__)

Gem::Specification.new do |s|
  s.name = "gem-empty"
  s.version = GemEmpty::VERSION
  s.authors = ["Michal Papis", "Andy Fleener", "Piotr Kuczynski"]
  s.email = ["mpapis@gmail.com", "anfleene@gmail.com", "piotr.kuczynski@gmail.com"]
  s.homepage = "https://github.com/rvm/gem-empty"
  s.summary = "Gem command to remove all gems from current GEM_HOME."
  s.license = "Apache 2.0"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.add_development_dependency("rake")
  s.add_development_dependency("minitest")
end
