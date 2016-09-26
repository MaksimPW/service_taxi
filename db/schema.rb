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

ActiveRecord::Schema.define(version: 20160926165827) do

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

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true

  create_table "order_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "car_id"
    t.integer  "driver_id"
    t.boolean  "status_buy"
    t.string   "operator"
    t.datetime "take_time"
    t.datetime "begin_time"
    t.datetime "end_time"
    t.string   "begin_address"
    t.string   "end_address"
    t.float    "cost"
    t.float    "distance"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "begin_lat"
    t.float    "begin_lon"
    t.float    "end_lat"
    t.float    "end_lon"
    t.integer  "order_type_id"
  end

  add_index "orders", ["car_id"], name: "index_orders_on_car_id"
  add_index "orders", ["driver_id"], name: "index_orders_on_driver_id"
  add_index "orders", ["order_type_id"], name: "index_orders_on_order_type_id"

  create_table "place_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade do |t|
    t.float    "lon"
    t.float    "lat"
    t.float    "radius"
    t.integer  "place_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "address"
  end

  add_index "places", ["place_type_id"], name: "index_places_on_place_type_id"

  create_table "settings", force: :cascade do |t|
    t.float    "max_diff_between_actual_track"
    t.integer  "max_rest_time_after_order"
    t.integer  "max_park_distance_after_order"
    t.integer  "max_rest_time"
    t.integer  "max_park_time"
    t.float    "max_diff_geo"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

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

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id"

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                         null: false
    t.integer  "item_id",                           null: false
    t.string   "event",                             null: false
    t.string   "whodunnit"
    t.text     "object",         limit: 1073741823
    t.datetime "created_at"
    t.text     "object_changes", limit: 1073741823
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id"

  create_table "waybills", force: :cascade do |t|
    t.string   "waybill_number"
    t.string   "car_number"
    t.string   "creator"
    t.string   "driver_alias"
    t.string   "fio"
    t.datetime "created_waybill_at"
    t.datetime "begin_road_at"
    t.datetime "end_road_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
