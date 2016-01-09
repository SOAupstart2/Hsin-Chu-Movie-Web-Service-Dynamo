require 'dynamoid'
require 'sinatra'

configure :test do
  Dynamoid.configure do |config|
    config.adapter = 'aws_sdk_v2'
    config.namespace = 'kandianying_api_test'
    config.warn_on_scan = false
    config.read_capacity = 5
    config.write_capacity = 5
  end
end

configure :development, :production do
  Dynamoid.configure do |config|
    config.adapter = 'aws_sdk_v2'
    config.namespace = 'kandianying_api'
    config.warn_on_scan = false
    config.read_capacity = 5
    config.write_capacity = 5
  end
end
