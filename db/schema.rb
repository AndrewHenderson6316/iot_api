# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_10_16_213234) do
  create_table "data_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.integer "data_type_id", null: false
    t.integer "device_id", null: false
    t.integer "time_of_sample_id", null: false
    t.index ["data_type_id"], name: "index_data_entries_on_data_type_id"
    t.index ["device_id"], name: "index_data_entries_on_device_id"
    t.index ["time_of_sample_id"], name: "index_data_entries_on_time_of_sample_id"
  end

  create_table "data_types", force: :cascade do |t|
    t.string "typeName"
    t.string "scale"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string "manufacturer_name"
    t.string "description"
    t.string "friendly_name"
    t.string "model"
    t.string "serial_number"
    t.string "firmware_version"
    t.string "software_version"
    t.string "custom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "categories"
  end

  create_table "time_of_samples", force: :cascade do |t|
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "data_entries", "data_types"
  add_foreign_key "data_entries", "devices"
  add_foreign_key "data_entries", "time_of_samples"
end
