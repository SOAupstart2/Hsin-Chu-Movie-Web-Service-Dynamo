require 'base64'

AN_HOUR = 1 / 24.to_f
TIMEZONE = '+8'
MIDNIGHT = %w(00 01 02 03)

# Service object to search movie tables
class SearchMovieTable
  def initialize(search_type, data)
    # search_type can be either 'name', 'time' or 'name_time'
    @search_type = search_type
    @date_time = data[:date_time]
    @query_param = search_type == 'time' ? data[:date_time] : data[:film_name]
    @movie_names = JSON.parse(Base64.urlsafe_decode64(
                                data[:data]['movie_names']))
    @movie_table = JSON.parse(Base64.urlsafe_decode64(
                                data[:data]['movie_table']))
  end

  def call
    if @search_type == 'name'
      film_times
    elsif @search_type == 'time'
      films_after_time
    elsif @search_type == 'name_time'
      # Get results from film name search
      # Alter global variables to use film_name_search results
      # Set query_param to date_time for films_after_time search
      @movie_table = [film_times].to_h
      @query_param = @date_time
      films_after_time
    end
  end

  def find_film
    film_name = @query_param.downcase
    @movie_names.select { |name| name if name.downcase.include? film_name }
  end

  def film_times(temp_table = {})
    find_film.each do |film|
      temp_table[film] = @movie_table.values[0][film]
    end
    [@movie_table.keys[0], temp_table]
  end

  def films_on_day(temp_table = {})
    search_datetime = DateTime.parse("#{@query_param}#{TIMEZONE}")
    @movie_table.values[0].each do |name, date_time|
      date_time.each do |date, times|
        if DateTime.parse(date).to_date == search_datetime.to_date
          temp_table[name] = { date => times }
        end; end; end
    temp_table
  end

  def time_after(date, times, time_preferrence)
    times.select do |time|
      time if (MIDNIGHT.include? time[0..1]) ||
              (DateTime.parse("#{date} #{time}#{TIMEZONE}") >= time_preferrence)
    end
  end

  def films_after_time(temp_table = {})
    search_datetime = DateTime.parse("#{@query_param}#{TIMEZONE}") - AN_HOUR
    films_on_day.each do |name, date_time|
      date_time.each do |date, times|
        time_array = time_after(date, times, search_datetime)
        temp_table[name] = { date => time_array } unless time_array.empty?
      end
    end
    [@movie_table.keys[0], temp_table]
  end
end
