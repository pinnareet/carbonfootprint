class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.column :name,       :string
      t.column :location,   :string
      t.column :footprint,  :integer
      t.column :num_attend, :integer
    end
  end
end
