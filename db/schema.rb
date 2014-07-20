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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140719072425) do

  create_table "csv_for_shares", force: true do |t|
    t.string "link_id"
    t.text "data"
    t.integer 'file_size'
    t.integer "num_lines"
    t.string 'download_link'
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "original_file_name"
  end

  add_index "csv_for_shares", ["link_id"], name: "index_csv_for_shares_on_link_id"

end
