class HomeController < ApplicationController
  def index
    f = File.open('public/conference_attendee_list/aiea_2010.txt')
    @list = f.readlines
    f.close
    @conference = Conference.find(1); #temporary
  end

  def display
    @conferences = Conference.all

    respond_to do |format|
      format.html
      format.xls {
        send_data(@conferences.to_xls)
      }
    end
  end
end
