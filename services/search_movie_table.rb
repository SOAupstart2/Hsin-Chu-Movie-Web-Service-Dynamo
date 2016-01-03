AN_HOUR = 1 / 24.to_f
TIMEZONE = '+8'
MIDNIGHT = %w(00 01 02 03)

# Service object to search movie tables
class SearchMovieTable
  def initialize(search_type, data)
    # search_type can be either 'name' or 'time'
    @search_type = search_type
    @query_param = search_type == 'name' ? data[:film_name] : data[:date_time]
    @movie_names = JSON.parse data[:data]['movie_names']
    @movie_table = JSON.parse data[:data]['movie_table']
  end

  def call
    @search_type == 'name' ? film_times : films_after_time
  end

  def find_film
    film_name = @query_param.downcase
    @movie_names.select { |name| name if name.downcase.include? film_name }
  end

  def film_times(temp_table = {})
    find_film.each do |film|
      temp_table[film] = @movie_table.values[0][film]
    end
    temp_table
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
    temp_table
  end
end
