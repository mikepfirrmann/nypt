class Trip < ActiveRecord::Base
  belongs_to :route
  belongs_to :shape
end
