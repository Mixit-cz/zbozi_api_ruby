$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'dotenv/load'
require "zbozi_api_ruby"
require "minitest/autorun"
require 'vcr'
require 'simplecov'

SimpleCov.start

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
