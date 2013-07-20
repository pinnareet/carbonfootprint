class Attendee < ActiveRecord::Base
  attr_accessible :name, :location, :distance, :conference_id, :latitude, :longitude, :coordinates
  belongs_to :conference
  geocoded_by :location
  after_validation :geocode

  def coordinates
    [latitude, longitude]
  end

end
