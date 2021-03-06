require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock/minitest'
require 'yaml'
require 'virtus'

ENV['RACK_ENV'] = 'test'

Dir.glob('./{models,helpers,config,values,services,controllers,workers}/'\
  'init.rb').each do |file|
  require file
end

include Rack::Test::Methods

CINEMA = {
  vieshow: %w(05 12),
  ambassador: %w(38897fa9-094f-4e63-9d6d-c52408438cb6
                 5c2d4697-7f54-4955-800c-7b3ad782582c)
}
LANGUAGE = %w(chinese english)
VIESHOW_FAIL_SITES = 10.times.map { Random.new.rand(100) } - (1..14).to_a
AMB_FAIL_SITES = 10.times.map { Random.new.rand(10_000..20_000) }
FIX = {
  vieshow: './spec/fixtures/vieshow_',
  ambassador: './spec/fixtures/ambassador_'
}

def app
  ApplicationController
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassette'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

def yml_load(file)
  YAML.load(File.read(file))
end
