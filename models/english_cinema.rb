require 'dynamoid'

# Saving english cinema data into db
class EnglishCinema
  include Dynamoid::Document

  field :location, :string
  field :data, :string
end
