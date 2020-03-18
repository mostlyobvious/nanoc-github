require_relative "../lib/nanoc/github"
require "minitest/autorun"
require "webmock/minitest"
require "vcr"


VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures"
  config.hook_into :webmock
end
