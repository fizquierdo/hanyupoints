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

ActiveRecord::Schema.define(version: 20150405004425) do

  create_table "grammar_point_examples", force: true do |t|
    t.integer  "grammar_point_id"
    t.string   "sentence"
    t.string   "pinyin"
    t.string   "translation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grammar_point_examples", ["grammar_point_id"], name: "index_grammar_point_examples_on_grammar_point_id"

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
    t.string   "link"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "words", force: true do |t|
    t.string   "han"
    t.string   "pinyin"
    t.string   "meaning"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_attempts", default: 0, null: false
    t.integer  "num_correct",  default: 0, null: false
    t.integer  "level"
    t.string   "pinyin_num"
  end

end
