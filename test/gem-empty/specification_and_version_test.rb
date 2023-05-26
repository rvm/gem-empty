require 'test_helper'
require 'gem-empty/specification'
require 'gem-empty/version'

describe GemEmpty::Specification do

  before do
    GemEmpty::Specification.instance_variable_set(:@gem_empty_spec, nil)
  end

  it "finds specification" do
    _(GemEmpty::Specification.find_gem_spec("gem-empty").name).must_equal("gem-empty")
  end

  it "does not find imaginary gems" do
    _(GemEmpty::Specification.find_gem_spec("imaginary-gem")).must_be_nil
  end

  it "confirms specification version" do
    _(GemEmpty::Specification.gem_loaded?("gem-empty", GemEmpty::VERSION)).must_equal true
  end

  it "does not confirms specification version" do
    _(GemEmpty::Specification.gem_loaded?("gem-empty", "0.0.0")).wont_equal true
  end
end