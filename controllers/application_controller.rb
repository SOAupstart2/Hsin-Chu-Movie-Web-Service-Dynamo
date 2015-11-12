require 'sinatra/base'
require 'sinatra/flash'
require 'httparty'
require 'hirb'
require 'slim'

# Web Service for Hsinchu cinemas
class ApplicationController < Sinatra::Base
  helpers AppHelpers
  enable :sessions
  enable :logging
  register Sinatra::Flash
  use Rack::MethodOverride

  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)

  # configure do
  #   Hirb.enable
  #   set :session_secret, 'something'
  #   set :api_ver, 'api/v1'
  # end

  # configure :development, :test do
  #   set :api_server, 'http://localhost:9292'
  # end

  # configure :production do
  #   set :api_server, 'http://kandianying.herokuapp.com'
  # end

  # configure :production, :development do
  #   enable :logging
  # end

  api_get_root = lambda do
    'Welcome to our API v1. Here\'s '\
    ' <a href="https://github.com/SOAupstart2/Hsin-Chu-Movie-Web-Service">'\
    'our github homepage</a>.'
  end

  api_get_movie_name = lambda do
    content_type :json
    cinema_names(params[:theater_id])
  end

  api_get_movie_info = lambda do
    content_type :json
    cinema_table(params[:theater_id])
  end

  api_get_user_info = lambda do
    content_type :json
    begin
      user = User.find(params[:id])
      location = user.location
      language = user.language
      film_name = params[:name]
      date_time = params[:time]
      logger.info({ id: user.id,
                    location: location,
                    language: language,
                    name: film_name,
                    time: date_time
                    }.to_json)
    rescue => e
      logger.error "Fail: #{e}"
      halt 404
    end

    user_info = { id: user.id,
                  location: location,
                  language: language }
    search_name = film_name ? film_times(location, film_name) : {}
    search_time = date_time ? films_after_time(location, date_time) : {}

    {user_info: user_info,
     search_name: search_name,
     search_time: search_time}.to_json
  end

  api_post_user_info = lambda do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
      logger.info req
    rescue
      halt 400
    end

    user = User.new(
      location: req['location'],
      language: req['language'])

    if user.save
      status 201
      redirect "/api/v1/users/#{user.id}", 303
    else
      halt 500, 'Error saving user request to the database'
    end
  end
  
  # Web API Routes
  get '/api/v1/?', &api_get_root
  get '/api/v1/cinema/:theater_id/movies/?', &api_get_movie_name
  get '/api/v1/cinema/:theater_id.json', &api_get_movie_info
  get '/api/v1/users/:id/?', &api_get_user_info
  post '/api/v1/users/?', &api_post_user_info
  
  helpers do
    def current_page?(path = ' ')
      path_info = request.path_info
      path_info += ' ' if path_info == '/'
      request_path = path_info.split '/'
      request_path[1] == path
    end
  end

  app_get_root = lambda do
    slim :home
  end

  # Web App Views Routes
  get '/', &app_get_root




end
