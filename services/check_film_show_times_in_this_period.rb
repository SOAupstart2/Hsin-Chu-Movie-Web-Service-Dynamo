# Class to get current films and show times
class CheckFilmShowTimesInThisPeriod
  def initialize(cinema)
    @cinema = cinema
  end

  def call
    @cinema.movie_table.to_s
  end
end
