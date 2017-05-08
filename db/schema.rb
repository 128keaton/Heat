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

ActiveRecord::Schema.define(version: 20170508140655) do

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
  end

end
