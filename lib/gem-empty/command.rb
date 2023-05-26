require 'gem-empty/specification'
require 'rubygems/command_manager'
require 'rubygems/uninstaller'
require 'rubygems/version'
require 'fileutils'

# rubygems plugin to empty GEM_HOME
class EmptyCommand < Gem::Command
  attr_reader :options

  GEM_REMOVAL_ERRORS = [
    Gem::DependencyRemovalException,
    Gem::InstallError,
    Gem::GemNotInHomeException,
    Gem::FilePermissionError,
  ]

  def initialize
    super 'empty', description
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
    "Remove all gems from current 'GEM_HOME'."
  end

  def execute(opts = {})
    remove_gems(opts)
  rescue *GEM_REMOVAL_ERRORS => exception
    alert_error "#{exception.class}: #{exception.message}"
  end

private

  # A method so it's evaluated as late as possible
  # giving chance to change Gem.dir
  def self.default_options
    {
      :install_dir => Gem.dir,
      :force       => true,
      :executables => true,
    }
  end

  def remove_gems(opts)
    @options = self.class.default_options.merge(opts)
    remove_rubygems_gems
    remove_bundler_gems
  end

  def remove_rubygems_gems
    uninstaller = Gem::Uninstaller.new(nil, options)
    uninstaller.remove_all(gem_dir_specs)
  end

  def remove_bundler_gems
    FileUtils.rm_rf(File.join(gem_install_dir, 'bundler', 'gems'))
  end

  def gem_dir_specs
    @gem_dir_specs ||=
      GemEmpty::Specification.installed_gems.select do |spec|
        File.exist?(File.join(gem_install_dir, 'gems', spec.full_name))
      end
  end

  def gem_install_dir
    options[:install_dir]
  end

end
