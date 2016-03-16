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

ActiveRecord::Schema.define(version: 20160316125330) do

  create_table "route_jobs", force: :cascade do |t|
    t.string   "job_id"
    t.boolean  "result"
    t.integer  "route_id"
    t.integer  "true"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "route_transports", force: :cascade do |t|
    t.string   "route_type"
    t.integer  "duration"
    t.integer  "price"
    t.integer  "route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "route_transports", ["route_id"], name: "index_route_transports_on_route_id"

  create_table "routes", force: :cascade do |t|
    t.string   "start"
    t.string   "end"
    t.text     "cache"
    t.time     "delta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "full_start"
    t.string   "full_end"
  end

end
