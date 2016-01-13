# Service class to check time for a given film
class CheckTimesForFilm
  include AppHelpers
  def initialize(search_info)
    @film_name = search_info.name
    @date_time = search_info.time if search_info.time
    @language = search_info.language
    @location = search_info.location
    @search_type = search_info.time ? 'name_time' : 'name'
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
        result.push(
          SearchMovieTable.new(@search_type, film_name: @film_name, data: data,
                                             date_time: @date_time).call)
      end; end
    result.to_h
  rescue => e
    puts "Fail: #{e}"
    raise 'What could possibly go wrong? Bad inputs?'
  end
end
