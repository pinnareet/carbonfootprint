class AddLatitudeAndLongitudeToConference < ActiveRecord::Migration
  def change
    add_column :conferences, :latitude, :float
    add_column :conferences, :longitude, :float
  end
end
