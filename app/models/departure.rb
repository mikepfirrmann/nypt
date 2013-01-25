class Departure < ActiveRecord::Base
  belongs_to :block
  belongs_to :calendar_date
  belongs_to :service

  validates :track, :numericality => { :only_integer => true, :greater_than => 0 }
end
