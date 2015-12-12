require 'dynamoid'
# database Table
class User
  include Dynamoid::Document
  field :language, :string
  field :location, :string
  field :search, :string

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end

# require 'sinatra'
# require 'sinatra/activerecord'
# require_relative '../config/environments'

# class User < ActiveRecord::Base
# end
