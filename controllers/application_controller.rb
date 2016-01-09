require 'sinatra/base'
require 'httparty'
require 'hirb'

# Web Service for Hsinchu cinemas
class ApplicationController < Sinatra::Base
  use Rack::MethodOverride
  helpers AppHelpers
  enable :sessions

  configure do
    Hirb.enable
  end

  configure :development, :test do
    set :api_server, 'http://localhost:9292'
    set :api_ver, 'api/v1'
  end

  configure :production do
    set :api_server, 'http://kandianying.herokuapp.com'
    set :api_ver, 'api/v1'
  end

  configure :production, :development do
    enable :logging
  end

  api_get_root = lambda do
    "Welcome to our API v1. Here's <a "\
    'href="https://github.com/SOAupstart2/Hsin-Chu-Movie-Web-Service-Dynamo">'\
    'our github homepage</a>.'
  end

  api_get_movie_name = lambda do
    content_type :json, charset: 'utf-8'
    cinema = create_cinema(params)
    movies = CheckFilmsOnDisplayInThisPeriod.new cinema
    movies.call
  end

  api_get_movie_info = lambda do
    content_type :json, charset: 'utf-8'
    cinema = create_cinema(params)
    show_times = CheckFilmShowTimesInThisPeriod.new cinema
    show_times.call
  end

  api_get_search_info = lambda do
    content_type :json, charset: 'utf-8'

    req = if params.empty?
            halt 400 if request.body.empty?
            JSON.parse(request.body.read.to_s)
          else params
          end
    search_info = SearchInfo.new(req)

    begin
      search = SearchSanitizer.new(location: search_info.location,
                                   language: search_info.language)
      halt 400 unless search.valid?
    rescue => e
      logger.error "Fail: #{e}"
      halt 400
    end

    search_name =
    search_info.name ? CheckTimesForFilm.new(search_info).call : {}
    search_time =
    search_info.time ? CheckFilmsAfterTime.new(search_info).call : {}
    { search_info: search_info.to_h, search_name: search_name,
      search_time: search_time }.to_json
  end

  # Web API Routes v1
  ['/', '/api/v1/?'].each { |path| get path, &api_get_root }
  get '/api/v1/:cinema/:language/:theater_id/movies/?', &api_get_movie_name
  get '/api/v1/:cinema/:language/:theater_id.json', &api_get_movie_info
  get '/api/v1/search/?', &api_get_search_info
end
