class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.column :name,           :string
      t.column :location,       :string
      t.column :distance,       :integer
      t.column :conference_id,  :integer
    end
  end
end
