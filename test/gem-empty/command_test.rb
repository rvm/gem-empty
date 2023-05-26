require 'test_helper'
require 'gem-empty/command'
require 'rubygems/installer'
require 'rubygems/user_interaction'
require 'rubygems/mock_gem_ui'

class Gem::Specification
  def self.remove_spec spec
    true # fake the removal from _all
  end
end

describe EmptyCommand do
  include Gem::DefaultUserInteraction

  subject do
    EmptyCommand.new
  end

  it "has some strings" do
    subject.arguments.class.must_equal(String)
    subject.usage.class.must_equal(String)
    subject.defaults_str.class.must_equal(String)
    subject.description.class.must_equal(String)
    subject.program_name.class.must_equal(String)
  end

  describe "gem-empty" do
    before do
      file = Tempfile.new('command-empty')
      @test_path = file.path
      file.close
      file.unlink
      @ui = Gem::MockGemUi.new
      @found_minitest = Gem::Specification.find_by_name('minitest')
      package = RUBY_VERSION >= "2.3" ? Gem::Package.new(@found_minitest.cache_file) : @found_minitest.cache_file
      installer = Gem::Installer.new(package, :version => @found_minitest.version, :install_dir => @test_path)
      bundler_git_gems_path = File.join(@test_path,'bundler','gems')
      FileUtils.mkdir_p(bundler_git_gems_path)
      @git_gem_file = File.join(bundler_git_gems_path, 'git-test')
      FileUtils.touch(@git_gem_file)
      use_ui @ui do
        installer.install
      end
      subject.instance_variable_set(:@gem_dir_specs, [installer.spec])
    end

    after do
      FileUtils.rm_rf(@test_path)
    end

    it "removes gems" do
      File.exist?(File.join(@test_path, "gems", @found_minitest.full_name)).must_equal(true)
      use_ui @ui do
        subject.execute(:install_dir => @test_path)
      end
      File.exist?(File.join(@test_path, "gems", @found_minitest.full_name)).must_equal(false)
      @ui.output.must_match(
        /Successfully uninstalled minitest-/
      )
      @ui.error.must_equal("")
    end

    it "removes git gems installed via bundler" do
      File.exist?(@git_gem_file).must_equal(true)
      use_ui @ui do
        subject.execute(:install_dir => @test_path)
      end
      File.exist?(@git_gem_file).must_equal(false)
      @ui.error.must_equal("")
    end

    it "fails gems" do
      File.chmod(0500, File.join(@test_path) )
      use_ui @ui do
        subject.execute(:install_dir => @test_path)
      end
      File.exist?(File.join(@test_path, "gems", @found_minitest.full_name)).must_equal(true)
      File.chmod(0755, File.join(@test_path) )
      @ui.output.must_equal("")
      @ui.error.must_match(
        /ERROR:  Gem::FilePermissionError: You don't have write permissions for the .* directory/
      )
    end

  end

  it "finds gem executables" do
    subject.stub :options, {:install_dir => Gem.dir } do
      subject.send(:gem_dir_specs).map{|spec| spec.name}.must_include('minitest')
    end
  end

end
