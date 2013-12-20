require 'test_helper'
require 'gem-empty/specification'
require 'gem-empty/version'

describe GemEmpty::Specification do

  it "finds specification" do
    GemEmpty::Specification.find.name.must_equal("gem-empty")
  end

  it "gets specification version" do
    GemEmpty::Specification.version.must_equal(GemEmpty::VERSION)
  end

end
