# Value object for search information
class SearchInfo
  attr_accessor :location, :language, :name, :time

  def initialize(req)
    @location = req['location']
    @language = req['language']
    @name = req['name']
    @time = req['time']
  end

  def to_h
    {
      location: @location, language: @language,
      search_name: @name, search_time: @time
    }
  end
end
