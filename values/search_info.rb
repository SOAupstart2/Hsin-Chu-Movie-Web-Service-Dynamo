# Value object for search information
class SearchInfo
  attr_accessor :location, :language, :name, :time

  def initialize(req)
    @location = req['location']
    @language = req['language']
    @name = req['name'] unless req['name'].nil? || req['name'].empty?
    @time = req['time'] unless req['time'].nil? || req['time'].empty?
  end

  def to_h
    {
      location: @location, language: @language,
      search_name: @name, search_time: @time
    }
  end
end
