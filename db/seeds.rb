# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Create initial conference and attendees
#Read input files
#Conference.find(10).destroy
#Attendee.where(:conference_id => 10).destroy_all

files = Dir.glob("public/conference_attendee_list/*")
for file in files
  list = Array.new()
  f = File.open(file)
  f.each_line {|line|
    list << line.delete("\n")
  }
  f.close
  num_attend = (list.length)/2 - 1;
  if !Conference.find_by_name(list[0]) then
    test = Conference.create(:name => list[0], :location => list[1], :num_attend => num_attend)
    for i in 1..num_attend
      attendee = Attendee.create(:name => list[2*i], :location => list[2*i+1], :conference_id => test.id)
    end
  end
end

Attendee.all.each do |attendee|
  if attendee.distance == nil then
    if attendee.geocoded? then
      attendee.update_attribute :distance, attendee.distance_from(attendee.conference.coordinates)
      #already stored as integer
    end
  end
end

Conference.all.each do |conference|
  if conference.footprint == nil then
    sum = 0
    num_valid = 0
    conference.attendees.each do |attendee|
      if attendee.distance then
        sum += attendee.distance
        num_valid += 1
      end
    end
    conference.update_attribute :footprint, sum
    conference.update_attribute :num_valid, num_valid
    conference.update_attribute :avg_dist, sum/num_valid
  end
end