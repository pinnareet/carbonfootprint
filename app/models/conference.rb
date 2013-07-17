class Conference < ActiveRecord::Base
  attr_accessible :name, :location, :footprint, :num_attend
  has_many :attendees
end
