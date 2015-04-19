require 'gem-empty/specification'
require 'rubygems/command_manager'
require 'rubygems/uninstaller'
require 'rubygems/version'
require 'fileutils'

class EmptyCommand < Gem::Command
  attr_accessor :options

  def initialize
    super 'empty', 'Remove all gems from current GEM_HOME.'
    self.options = { :install_dir => Gem.dir, :force => true, :executables => true }
  end

  def arguments # :nodoc:
    "empty        remove all gems from current GEM_HOME."
  end

  def usage # :nodoc:
    "#{program_name}"
  end

  def defaults_str # :nodoc:
    ""
  end

  def description # :nodoc:
    <<-DOC
Remove all gems from current 'GEM_HOME'.
DOC
  end

  def execute(opts = {})
    self.options = options.merge(opts)
    uninstaller = Gem::Uninstaller.new(nil, options)
    uninstaller.remove_all(gem_dir_specs)

    # Remove any Git gems installed via bundler
    FileUtils.rm_rf(File.join(options[:install_dir] || Gem.dir,'bundler','gems'))

  rescue Gem::DependencyRemovalException,
         Gem::InstallError,
         Gem::GemNotInHomeException,
         Gem::FilePermissionError => e

    alert_error "#{e.class}: #{e.message}"
  end

private

  def gem_dir_specs
    @gem_dir_specs ||=
    GemEmpty::Specification.installed_gems.select do |spec|
      File.exists?( File.join( options[:install_dir], 'gems', spec.full_name ) )
    end
  end

end
