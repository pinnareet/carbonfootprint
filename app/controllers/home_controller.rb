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

  def attendees
    @conference_id = params[:id].to_i
    @conference = Conference.find(@conference_id)
    @attendee = Array.new()
    Attendee.all.each do |attendee|
      if attendee.conference_id == @conference_id then
        @attendee << attendee
      end
    end
    if @attendee then
      respond_to do |format|
        format.html
        format.xls {
          send_data(@attendee.to_xls)
        }
        format.csv {
          send_data(@attendee.to_csv)
        }
      end
    end
  end

  def capri
    @user = Capri.all
    respond_to do |format|
      format.html
      format.xls {
        send_data(@user.to_xls)
      }
      format.csv {
        send_data(@user.to_csv)
      }
    end
  end
end
