class Departure < ActiveRecord::Base
  belongs_to :calendar_date
  belongs_to :trip

  validates :track, :numericality => { :only_integer => true, :greater_than => 0 }
end
