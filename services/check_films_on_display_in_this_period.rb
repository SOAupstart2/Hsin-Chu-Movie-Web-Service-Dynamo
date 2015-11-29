# Class to get current list of films
class CheckFilmsOnDisplayInThisPeriod
  def initialize(cinema)
    @cinema = cinema
  end

  def call
    @cinema.movie_names.to_json
  end
end
