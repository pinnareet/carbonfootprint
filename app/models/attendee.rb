class Attendee < ActiveRecord::Base
  attr_accessible :name, :location, :distance, :conference_id
  belongs_to :conference
end
