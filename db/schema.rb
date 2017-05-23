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

ActiveRecord::Schema.define(version: 20170523165633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "machines", force: :cascade do |t|
    t.string   "serial_number"
    t.string   "client_asset_tag"
    t.string   "reviveit_asset_tag"
    t.json     "unboxed"
    t.json     "imaged"
    t.json     "racked"
    t.json     "deployed"
    t.string   "notes"
    t.string   "role"
    t.string   "rack"
    t.boolean  "doa"
    t.json     "special_instructions"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "location"
    t.integer  "pallet_id"
  end

  create_table "rack_carts", force: :cascade do |t|
    t.string   "rack_id"
    t.text     "children"
    t.boolean  "full"
    t.integer  "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.json     "specs"
    t.string   "suffix"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "pallet_count"
    t.integer  "pallet_layer_count"
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.boolean  "blended_learning"
    t.json     "quantity"
    t.string   "school_code"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "location"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
    t.boolean  "admin",                  default: false
    t.boolean  "supervisor",             default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
