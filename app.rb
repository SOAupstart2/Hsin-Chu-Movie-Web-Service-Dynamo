require 'sinatra'
require 'kandianying'

# Web Service for Hsinchu cinema
class HsinchuMoveWebService < Sinatra::Base
  get '/' do
    'Welcome to our API v1. Here\'s '\
    ' <a href="https://github.com/SOAupstart2/Hsin-Chu-Movie-Web-Service">'\
    'our github homepage</a>.'
  end

  get '/api/v1/list-movies/?' do
    %w('0005', '0012').map do |cinema_id|
      HsinChuMovie.new(cinema_id).movie_table_output
    end
  end

  get '/api/v1/list-movies/:cinema_id.json' do
    HsinChuMovie.new(params['cinema_id']).movie_table_output
  end
end
