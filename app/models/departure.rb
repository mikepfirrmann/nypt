class Departure < ActiveRecord::Base
  belongs_to :trip

  validates :day, :presence => true
  validates :track, :numericality => { :only_integer => true, :greater_than => 0 }
end
