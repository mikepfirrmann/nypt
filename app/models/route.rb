class Route < ActiveRecord::Base
  belongs_to :agency
  has_many :trips
  has_many :stops, :through => :trips
end
