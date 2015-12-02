# Service class to check for films shown after a given time
class CheckFilmsAfterTime
  include AppHelpers
  def initialize(user_info, date_time)
    location = Location.new(user_info.location)
    @location_codes = location.codes
    @date_time = date_time
    @language = user_info.language
  end

  def call(result = [])
    @location_codes.each do |vie_amb, codes|
      codes.each do |code|
        params = { theater_id: code, language: @language, cinema: vie_amb }
        cinema = create_cinema(params)
        result.push([cinema.cinema_name, cinema.films_after_time(@date_time)])
      end; end
    result.to_h
  rescue => e
    puts "Fail: #{e}"
    raise 'What could possibly go wrong? Bad inputs?'
  end
end
