class Conference < ActiveRecord::Base
  attr_accessible :name, :location, :footprint, :num_attend, :latitude, :longitude, :coordinates, :num_valid
  has_many :attendees
  geocoded_by :location
  after_validation :geocode


  def coordinates
    [latitude, longitude]
  end
end
