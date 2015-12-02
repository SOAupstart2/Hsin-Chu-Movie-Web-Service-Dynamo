# Service class to check time for a given film
class CheckTimesForFilm
  include AppHelpers
  def initialize(user_info, film_name)
    location = Location.new(user_info.location)
    @location_codes = location.codes
    @film_name = film_name
    @language = user_info.language
  end

  def call(result = [])
    @location_codes.each do |vie_amb, codes|
      codes.each do |code|
        params = { theater_id: code, language: @language, cinema: vie_amb }
        cinema = create_cinema(params)
        result.push([cinema.cinema_name, cinema.film_times(@film_name)])
      end; end
    result.to_h
  rescue => e
    puts "Fail: #{e}"
    raise 'What could possibly go wrong? Bad inputs?'
  end
end
