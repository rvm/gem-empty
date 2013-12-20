require 'test_helper'
require 'gem-empty/specification'
require 'gem-empty/version'

describe GemEmpty::Specification do

  before do
    GemEmpty::Specification.instance_variable_set(:@gem_empty_spec, nil)
  end

  it "finds specification" do
    GemEmpty::Specification.find("gem-empty").name.must_equal("gem-empty")
  end

  it "gets specification version" do
    GemEmpty::Specification.version.must_equal(GemEmpty::VERSION)
  end

  it "does not find imaginary gems" do
    GemEmpty::Specification.find("imaginary-gem").must_equal(nil)
  end

end
