require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext'

require 'config_env'
require 'aws-sdk'
require 'dalli'

class ApplicationController < Sinatra::Base
  configure :development, :test do
    ConfigEnv.path_to_config("#{__dir__}/../config/config_env.rb")
  end
end
