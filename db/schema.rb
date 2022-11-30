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

ActiveRecord::Schema[7.0].define(version: 2022_11_30_052505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.string "sub_category"
    t.bigint "day_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_categories_on_day_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.string "location"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.string "api"
    t.string "rating"
    t.bigint "category_id"
    t.float "latitude"
    t.float "longitude"
    t.integer "position"
    t.index ["category_id"], name: "index_contents_on_category_id"
  end

  create_table "days", force: :cascade do |t|
    t.integer "number"
    t.bigint "itinerary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_days_on_itinerary_id"
  end

  create_table "itineraries", force: :cascade do |t|
    t.string "title"
    t.bigint "employee_id"
    t.bigint "client_id"
    t.integer "status"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "min_budget"
    t.integer "max_budget"
    t.boolean "archived", default: false
    t.date "start_date"
    t.date "end_date"
    t.string "Interests"
    t.index ["client_id"], name: "index_itineraries_on_client_id"
    t.index ["employee_id"], name: "index_itineraries_on_employee_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unused_contents", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.string "location"
    t.string "description"
    t.string "api"
    t.string "rating"
    t.string "category_title"
    t.string "category_type"
    t.string "category_sub_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "itinerary_id"
    t.float "latitude"
    t.float "longitude"
    t.index ["itinerary_id"], name: "index_unused_contents_on_itinerary_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone"
    t.string "zipcode"
    t.string "street"
    t.string "city"
    t.string "country"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "days"
  add_foreign_key "days", "itineraries"
  add_foreign_key "itineraries", "users", column: "client_id"
  add_foreign_key "itineraries", "users", column: "employee_id"
end
