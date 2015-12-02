require 'kandianying'
require 'json'

# Module for Cinema classes helper methods
module CinemaInfoMethods
  def film_times(film_name)
    @cinema.film_times(film_name)
  end

  def films_after_time(date_time)
    @cinema.films_after_time(date_time)
  end
end

# Cinema information Class for API v1
class CinemaInfo
  include CinemaInfoMethods
  attr_reader :cinema

  def initialize(theater_id, language, cinema)
    if cinema == 'vieshow'
      @cinema = HsinChuMovie::Vieshow.new(theater_id, language)
    elsif cinema == 'ambassador'
      @cinema = HsinChuMovie::Ambassador.new(theater_id, language)
    end
  end
end
