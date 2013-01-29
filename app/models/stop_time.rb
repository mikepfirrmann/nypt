require 'pseudo_time'

class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip

  validates_presence_of :arrival_time
  validates_presence_of :departure_time

  def arrival_time
    PseudoTime.new read_attribute(:arrival_time)
  end

  def departure_time
    PseudoTime.new read_attribute(:departure_time)
  end

end
