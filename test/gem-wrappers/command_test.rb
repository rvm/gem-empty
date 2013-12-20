require 'test_helper'
require 'gem-empty/command'
require 'rubygems/installer'

class Gem::Specification
  def self.remove_spec spec
    true # fake the removal from _all
  end
end

describe EmptyCommand do
  subject do
    EmptyCommand.new
  end

  describe "wrappers" do
    before do
      file = Tempfile.new('command-wrappers')
      @test_path = file.path
      file.close
      file.unlink
      found_rake = Gem::Specification.find_by_name('rake')
      installer = Gem::Installer.new(found_rake.cache_file, :version => found_rake.version, :install_dir => @test_path)
      installer.install
      subject.instance_variable_set(:@gem_dir_specs, [installer.spec])
    end

    after do
      FileUtils.rm_rf(@test_path)
    end

    it "regenerates wrappers" do
      File.exist?(File.join(@test_path, "gems", "rake-10.1.0")).must_equal(true)
      subject.execute(:install_dir => @test_path)
      File.exist?(File.join(@test_path, "gems", "rake-10.1.0")).must_equal(false)
    end
  end

  it "finds gem executables" do
    subject.send(:gem_dir_specs).map{|spec| spec.name}.must_include('minitest')
  end

end
