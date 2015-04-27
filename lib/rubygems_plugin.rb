# Simulate require_relative - it's required as the plugin can be called in wrong version or from bundler.
require File.expand_path('../gem-empty/specification.rb', __FILE__)

called_path, called_version = __FILE__.match(/^(.*\/gem-empty-([^\/]+)\/lib).*$/)[1..2]

# continue only if loaded and called versions all the same, and not shared gems disabled in bundler
if
  ( $:.include?(called_path) || GemEmpty::Specification.gem_loaded?("gem-empty", called_version) ) and
  ( !defined?(Bundler) || ( defined?(Bundler) && Bundler::SharedHelpers.in_bundle? && !Bundler.settings[:disable_shared_gems]) )
then
  require 'gem-empty/command'
  Gem::CommandManager.instance.register_command :empty
end
