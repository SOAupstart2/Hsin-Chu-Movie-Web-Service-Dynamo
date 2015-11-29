# Service class to check time for a given film
class CheckTimesForFilm
  include AppHelpers
  def initialize(location, language, film_name)
    location = Location.new(location)
    @location_codes = location.codes
    @film_name = film_name
    @language = language
  end

  def call(result = [])
    @location_codes.each do |vie_amb, codes|
      codes.each do |code|
        params = { theater_id: code, language: @language, cinema: vie_amb }
        cinema = cinema_v2(params).cinema
        result.push([cinema.cinema_name, cinema.film_times(@film_name)])
      end; end
    result.to_h
  rescue => e
    puts "Fail: #{e}"
    raise 'What could possibly go wrong? Bad inputs?'
  end
end
