require 'sinatra/base'

# Web Service for Hsinchu cinemas
class ApplicationController < Sinatra::Base
  helpers AppHelpers
  enable :logging

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

  get '/api/v1/users/:id/?' do
    content_type :json
    begin
      user = User.find(params[:id])
      location = user.location
      language = user.language
      logger.info({ id: user.id, location: location,
                    language: language }.to_json)
    rescue => e
      logger.error "Fail: #{e}"
      halt 404
    end

    { id: user.id, location: location,
      language: language }.to_json
  end

  post '/api/v1/users/?' do
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
end
