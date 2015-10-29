require_relative './model/kandianying_web'

# Helpers for main sinatra web application
module AppHelpers
  def cinema(theater_id)
    CinemaInfo.new(theater_id)
  end

  def cinema_names(theater_id)
    cinema(theater_id).movie_names
  rescue
    halt 404
  end

  def cinema_table(theater_id)
    cinema(theater_id).movie_table
  rescue
    halt 404
  end

  # def check_movie_info(movie_names, times)
  #   @check_info = {}
  #   movie_names.map do |movie_name|
  #     found = MovieInfo.new(movie_name).times
  #     [movie_name, times.select {|time| !found.include? time}]
  #   end.to_h
  # rescue
  #   halt 404
  # end
end
