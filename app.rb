require 'sinatra/base'
require_relative 'app_helper'

# Web Service for Hsinchu cinema
class HsinchuMovieWebService < Sinatra::Base
  helpers AppHelpers

  get '/' do
    'Welcome to our API v1. Here\'s '\
    ' <a href="https://github.com/SOAupstart2/Hsin-Chu-Movie-Web-Service">'\
    'our github homepage</a>.'
  end

  get '/api/v1/cinema/:theater_id/movies' do
    content_type :json
    cinema_names(params[:theater_id])
  end

  get '/api/v1/cinema/:theater_id.json' do
    content_type :json
    cinema_table(params[:theater_id])
  end
end
