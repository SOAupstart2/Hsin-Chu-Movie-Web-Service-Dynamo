require 'sinatra'

# Web Service for Hsinchu cinema
class HsinchuMoveWebService < Sinatra::Base
  get '/' do
    'Welcome to our API'
  end
end
