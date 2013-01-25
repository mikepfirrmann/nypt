class Trip < ActiveRecord::Base
  belongs_to :route
  belongs_to :shape
  belongs_to :block
  belongs_to :service

  has_many :stop_times

  has_many :stops, :through => :stop_times
end
