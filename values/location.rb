LOCATION = {
  'hsinchu' => {
    'vieshow' => %w(05 12),
    'ambassador' => %w(38897fa9-094f-4e63-9d6d-c52408438cb6)
  }
}

# Class for location
class Location
  attr_accessor :codes

  def initialize(city)
    @codes = LOCATION[city]
  end
end
