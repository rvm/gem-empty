require 'gem-empty/specification'
require 'rubygems/command_manager'
require 'rubygems/uninstaller'
require 'rubygems/version'

class EmptyCommand < Gem::Command
  def initialize
    super 'empty', 'remove all gems from current GEM_HOME.'
    @failed = {}
    @worked = []
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

  def execute(options = {})
    options = {:force => true, :executables => true }.merge(options)
    uninstaller = Gem::Uninstaller.new(nil, options)
    uninstaller.remove_all(gem_dir_specs)

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
      File.exists?( File.join( Gem.dir, 'gems', spec.full_name ) )
    end
  end

end
