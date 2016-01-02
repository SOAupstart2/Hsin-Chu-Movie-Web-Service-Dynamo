# Service class to check for films shown after a given time
class CheckFilmsAfterTime
  include AppHelpers
  def initialize(user_info, date_time)
    @date_time = date_time
    @language = user_info.language
    @location = user_info.location
  end

  def pick_cinema
    if @language == 'chinese'
      ChineseCinema.where(location: @location).all
    elsif @language == 'english'
      EnglishCinema.where(location: @location).all
    end[0]
  end

  def call(result = [])
    JSON.parse(pick_cinema.data.gsub('=>', ':')).each do |_vie_amb, codes|
      codes.each do |_code, data|
        res = SearchMovieTable.new('time', date_time: @date_time, data: data)
        result.push([data['cinema_name'], res.call])
      end; end
    result.to_h
  rescue => e
    puts "Fail: #{e}"
    raise 'What could possibly go wrong? Bad inputs?'
  end
end
