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

ActiveRecord::Schema.define(version: 20140521175155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "unaccent"

  create_table "delegaciones", force: true do |t|
    t.string   "url",        null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: true do |t|
    t.uuid     "user_id",    null: false
    t.string   "address",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", force: true do |t|
    t.uuid     "user_id",                               null: false
    t.string   "number",     limit: 10,                 null: false
    t.boolean  "cellphone",             default: false, null: false
    t.boolean  "morning",               default: false, null: false
    t.boolean  "afternoon",             default: false, null: false
    t.boolean  "night",                 default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "plate",              limit: 14,                 null: false
    t.datetime "confirmed_at"
    t.datetime "declined_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "adeudos",                       default: false, null: false
    t.boolean  "verificacion",                  default: false, null: false
    t.boolean  "no_circula_weekday",            default: false, null: false
    t.boolean  "no_circula_weekend",            default: false, null: false
  end

  create_table "verificentros", force: true do |t|
    t.integer  "number",        null: false
    t.string   "name",          null: false
    t.text     "address",       null: false
    t.integer  "delegacion_id", null: false
    t.string   "phone"
    t.float    "lat",           null: false
    t.float    "lon",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
