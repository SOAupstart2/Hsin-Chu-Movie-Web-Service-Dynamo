# ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock/minitest'
require 'yaml'
require_relative '../app'

include Rack::Test::Methods

TEST_SITES = %w(05 12)
FAIL_SITES = 10.times.map { Random.new.rand(100) } - (1..14).to_a
TEST_INFO = %w(name table)
FIXTURES = './spec/fixtures/vieshow_'

def app
  HsinchuMovieWebService
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassette'
  config.hook_into :webmock
end

def yml_load(file)
  YAML.load(File.read(file))
end
