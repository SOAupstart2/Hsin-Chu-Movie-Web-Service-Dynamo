require 'dynamoid'
require 'sinatra'

configure :development, :production, :test do
  Dynamoid.configure do |config|
    config.adapter = 'aws_sdk_v2'
    config.namespace = 'kandianying_api'
    config.warn_on_scan = false
    config.read_capacity = 5
    config.write_capacity = 5
  end
end
