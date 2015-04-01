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

ActiveRecord::Schema.define(version: 20150401195501) do

  create_table "grammar_points", force: true do |t|
    t.string   "level"
    t.string   "h1"
    t.string   "h2"
    t.string   "h3"
    t.string   "eng"
    t.string   "pattern"
    t.string   "example"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", force: true do |t|
    t.string   "han"
    t.string   "pinyin"
    t.string   "meaning"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_attempts", default: 0, null: false
    t.integer  "num_correct",  default: 0, null: false
    t.integer  "level"
  end

end
