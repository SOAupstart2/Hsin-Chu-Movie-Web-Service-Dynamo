require 'virtus'
require 'active_model'

ENG_CHI = %w(chinese english)
LOCATIONS = %w(kaohsiung taichung tainan hsinchu taipei
               new\ taipei\ city toufen pingtung kinmen)

# Customized ActiveRecord Validations
class DownCase < Virtus::Attribute
  def coerce(value)
    value.to_s.downcase
  end
end

# Value object to sanitize search
class SearchSanitizer
  include Virtus.model
  include ActiveModel::Validations

  attribute :language, DownCase
  validates_inclusion_of :language, in: ENG_CHI
  attribute :location, DownCase
  validates_inclusion_of :location, in: LOCATIONS
end
