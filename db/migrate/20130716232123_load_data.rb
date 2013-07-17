class LoadData < ActiveRecord::Migration
  def up
    #Create initial conference and attendees
    list = Array.new()
    f = File.open('public/conference_attendee_list/aiea_2010.txt')
    f.each_line {|line|
      list << line.delete("\n")
    }
    num_attend = (list.length)/2 - 1;
    test = Conference.new(:name => list[0], :location => list[1], :num_attend => num_attend)
    test.save()
    for i in 1..num_attend
      attendee = Attendee.new(:name => list[2*i], :location => list[2*i+1], :conference_id => test.id)
      attendee.save()
    end
    f.close
  end

  def down
    Conference.delete_all
    Attendee.delete_all
  end
end
