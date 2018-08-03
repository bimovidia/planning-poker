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

ActiveRecord::Schema.define(version: 20180801063748) do

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vote_id"
    t.integer  "project_id"
    t.integer  "story_id"
    t.string   "activity_type"
    t.text     "activity_data"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "activities", ["user_id"], name: "index_activities_on_user_id"
  add_index "activities", ["vote_id"], name: "index_activities_on_vote_id"

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "pivotal_id"
    t.string   "event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "salt"
    t.string "token"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "story_id"
    t.integer "vote"
    t.string  "user"
  end

end
