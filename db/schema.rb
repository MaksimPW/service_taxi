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

ActiveRecord::Schema.define(version: 20160915203128) do

  create_table "cars", force: :cascade do |t|
    t.string   "mark"
    t.string   "license_number"
    t.integer  "driver_id"
    t.text     "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "cars", ["driver_id"], name: "index_cars_on_driver_id"

  create_table "drivers", force: :cascade do |t|
    t.string   "fio"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "car_id"
    t.integer  "driver_id"
    t.boolean  "status_buy"
    t.string   "operator"
    t.datetime "take_time"
    t.datetime "begin_time"
    t.datetime "end_time"
    t.string   "begin_address_name"
    t.string   "end_address_name"
    t.float    "begin_geo"
    t.float    "end_geo"
    t.float    "cost"
    t.float    "distance"
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "orders", ["car_id"], name: "index_orders_on_car_id"
  add_index "orders", ["driver_id"], name: "index_orders_on_driver_id"

  create_table "status_cars", force: :cascade do |t|
    t.float    "geo_lat"
    t.float    "geo_lon"
    t.string   "license_number"
    t.float    "speed"
    t.datetime "fixed_time"
    t.string   "name"
    t.string   "model"
    t.integer  "id_car"
    t.integer  "ext_id"
    t.integer  "course"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
