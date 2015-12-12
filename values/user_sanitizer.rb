require 'virtus'
require 'active_model'

ENG_CHI = %w(chinese english)

# Customized ActiveRecord Validations
class DownCase < Virtus::Attribute
  def coerce(value)
    value.to_s.downcase
  end
end

# class to sanitize user prior to saving to db
class UserSanitizer
  include Virtus.model
  include ActiveModel::Validations

  attribute :language, DownCase
  attribute :search, DownCase
  validates_inclusion_of :language, in: ENG_CHI
  attribute :location, DownCase
end
