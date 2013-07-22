class HomeController < ApplicationController
  def index
    f = File.open('public/conference_attendee_list/aiea_2010.txt')
    @list = f.readlines
    f.close
    @conference = Conference.find(1); #temporary
  end

  def display

  end
end
