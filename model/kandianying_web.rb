require 'kandianying'
require 'json'

class CinemaInfo
  attr_reader :movie_table, :movie_names

  def initialize(theater_id)
    @cinema = HsinChuMovie::Vieshow.new(theater_id)
    @movie_table = @cinema.movie_table.to_s
    @movie_names = @cinema.movie_names.to_json
  end
end
