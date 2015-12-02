# class for User Info
class UserInfo
  attr_accessor :location, :language

  def initialize(user)
    @id = user.id
    @location = user.location
    @language = user.language
  end

  def to_h
    {
      id: @id, location: @location, language: @language
    }
  end
end
