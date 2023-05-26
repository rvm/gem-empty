require "os"

# Coverage only on newer ruby to avoid problems with older versions
if RUBY_VERSION == "3.0.0" && !OS.windows? && !OS.mac?
  require "coveralls"
  require "simplecov"

  SimpleCov.start do
    formatter SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter,
    ]
    command_name "Unit Tests"
    add_filter "/test/"
    add_filter "/demo/"
  end

  Coveralls.noisy = true unless ENV['CI']
end

require 'minitest/autorun'
require 'minitest/unit'
