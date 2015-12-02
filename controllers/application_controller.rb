require 'sinatra/base'
require 'httparty'
require 'hirb'

# Web Service for Hsinchu cinemas
class ApplicationController < Sinatra::Base
  use Rack::MethodOverride
  helpers AppHelpers
  enable :sessions

  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)

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
    "Welcome to our API v1. Here's "\
    '<a href="https://github.com/SOAupstart2/Hsin-Chu-Movie-Web-Service">'\
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

  api_get_user_info = lambda do
    content_type :json, charset: 'utf-8'
    begin
      user = User.find(params[:id])
      user_info = UserInfo.new(user)
      film_name = params[:name]
      date_time = params[:time]
    rescue => e
      logger.error "Fail: #{e}"
      halt 404
    end

    search_name = if film_name
                    CheckTimesForFilm.new(user_info, film_name).call
                  else {}
                  end
    search_time = if date_time
                    CheckFilmsAfterTime.new(user_info, date_time).call
                  else {}
                  end
    { user_info: user_info.to_h, search_name: search_name,
      search_time: search_time }.to_json
  end

  api_post_user_info = lambda do
    content_type :json, charset: 'utf-8'
    begin
      req = JSON.parse(request.body.read.to_s)
      user = UserSanitizer.new(
        location: req['location'], language: req['language']
      )
      halt 400 unless user.valid?
    rescue => e
      logger.error "Fail: #{e}"
      halt 400
    end

    user = User.new(location: user.location, language: user.language)

    if user.save
      status 201
      redirect "/#{settings.api_ver}/users/#{user.id}", 303
    else
      halt 500, 'Error saving user request to the database'
    end
  end

  # Web API Routes v1
  get '/', &api_get_root
  get '/api/v1/?', &api_get_root
  get '/api/v1/:cinema/:language/:theater_id/movies/?', &api_get_movie_name
  get '/api/v1/:cinema/:language/:theater_id.json', &api_get_movie_info
  get '/api/v1/users/:id/?', &api_get_user_info
  post '/api/v1/users/?', &api_post_user_info
end
