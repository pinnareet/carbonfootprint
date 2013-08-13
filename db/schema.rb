# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130813211159) do

  create_table "attendees", :force => true do |t|
    t.string  "name"
    t.string  "location"
    t.integer "distance"
    t.integer "conference_id"
    t.float   "latitude"
    t.float   "longitude"
  end

  create_table "capris", :force => true do |t|
    t.string  "full_name"
    t.integer "gender"
    t.integer "age"
    t.string  "affiliation"
    t.text    "mailing_address"
    t.integer "status"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "distance"
    t.integer "user_id"
  end

  create_table "commuters", :force => true do |t|
    t.integer  "user_id"
    t.string   "scan_time"
    t.integer  "location"
    t.integer  "direction"
    t.integer  "credit_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "month"
  end

  create_table "commutes", :force => true do |t|
    t.integer  "user_id"
    t.string   "scan_time"
    t.integer  "location"
    t.integer  "direction"
    t.integer  "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "conferences", :force => true do |t|
    t.string  "name"
    t.string  "location"
    t.integer "footprint"
    t.integer "num_attend"
    t.float   "avg_dist"
    t.integer "num_valid"
    t.float   "latitude"
    t.float   "longitude"
  end

  create_table "exits", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
