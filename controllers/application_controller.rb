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
  end

  configure :development do
    set :api_ver, 'api/v2'
  end

  configure :test do
    set :api_ver, 'api/v1'
  end

  configure :production do
    set :api_server, 'http://kandianying.herokuapp.com'
    set :api_ver, 'api/v1'
  end

  configure :production, :development do
    enable :logging
  end

  get_root = lambda do
    'Welcome. We\'ve  got 2 versions up and running:<br\><ul>'\
    '<li><a href="/api/v1">/api/v1</a> - tested but with limited'\
    ' functionality</li><li><a href="/api/v2">/api/v2</a> - no written tests '\
    'but much greater functionality</li></ul>'
  end

  api_get_root = lambda do
    "Welcome to our API #{params['version']}. Here's "\
    '<a href="https://github.com/SOAupstart2/Hsin-Chu-Movie-Web-Service">'\
    'our github homepage</a>.'
  end

  api_get_movie_name = lambda do
    content_type :json, charset: 'utf-8'
    cinema = create_cinema(request)
    movies = CheckFilmsOnDisplayInThisPeriod.new cinema
    movies.call
  end

  api_get_movie_info = lambda do
    content_type :json, charset: 'utf-8'
    cinema = create_cinema(request)
    show_times = CheckFilmShowTimesInThisPeriod.new cinema
    show_times.call
  end

  api_get_user_info = lambda do
    content_type :json, charset: 'utf-8'
    begin
      user = User.find(params[:id])
      location = user.location
      language = user.language
      film_name = params[:name]
      date_time = params[:time]
      # logger.info({ id: user.id, location: location, language: language,
      #               name: film_name, time: date_time }.to_json)
    rescue => e
      logger.error "Fail: #{e}"
      halt 404
    end

    user_info = { id: user.id, location: location, language: language }
    if request.path[6] == '1'
      search_name = film_name ? film_times(location, film_name) : {}
      search_time = date_time ? films_after_time(location, date_time) : {}
    elsif request.path[6] == '2'
      search_name =
        if film_name
          CheckTimesForFilm.new(location, language, film_name).call
        else {}
        end
      search_time =
        if date_time
          CheckFilmsAfterTime.new(location, language, date_time).call
        else {}
        end
    end

    { user_info: user_info, search_name: search_name,
      search_time: search_time }.to_json
  end

  api_post_user_info = lambda do
    content_type :json, charset: 'utf-8'
    begin
      req = JSON.parse(request.body.read)
      logger.info req
    rescue
      halt 400
    end

    user = User.new(location: req['location'], language: req['language'])

    if user.save
      status 201
      redirect "/#{settings.api_ver}/users/#{user.id}", 303
    else
      halt 500, 'Error saving user request to the database'
    end
  end

  get '/', &get_root

  # Web API Routes v1
  get '/api/:version/?', &api_get_root
  get '/api/v1/cinema/:theater_id/movies/?', &api_get_movie_name
  get '/api/v1/cinema/:theater_id.json', &api_get_movie_info
  get '/api/v1/users/:id/?', &api_get_user_info
  post '/api/v1/users/?', &api_post_user_info

  # Web API Routes v2
  get '/api/v2/:cinema/:language/:theater_id/movies/?', &api_get_movie_name
  get '/api/v2/:cinema/:language/:theater_id.json', &api_get_movie_info
  get '/api/v2/users/:id/?', &api_get_user_info
  post '/api/v2/users/?', &api_post_user_info
end
