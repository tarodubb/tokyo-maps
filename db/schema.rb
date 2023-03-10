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

ActiveRecord::Schema[7.0].define(version: 2023_03_09_071105) do
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

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.bigint "ward_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
    t.index ["ward_id"], name: "index_messages_on_ward_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "ward_id", null: false
    t.index ["user_id"], name: "index_reviews_on_user_id"
    t.index ["ward_id"], name: "index_reviews_on_ward_id"
  end

  create_table "user_wards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "ward_id", null: false
    t.index ["user_id"], name: "index_user_wards_on_user_id"
    t.index ["ward_id"], name: "index_user_wards_on_ward_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "avatar"
    t.float "latitude"
    t.float "longitude"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wards", force: :cascade do |t|
    t.string "name"
    t.text "summary"
    t.string "flag"
    t.integer "one_ldk_avg_rent"
    t.integer "two_ldk_avg_rent"
    t.integer "three_ldk_avg_rent"
    t.string "safety"
    t.integer "school_ratings"
    t.integer "population"
    t.integer "population_density"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "geojson"
    t.text "points_of_interest", array: true
    t.string "historical_significance"
    t.integer "ward_code"
    t.float "latitude"
    t.float "longitude"
    t.float "transportation_rating"
    t.float "shopping_rating"
    t.float "entertainment_rating"
    t.float "security_rating"
    t.float "natural_disaster_safety_rating"
    t.float "housing_cost_satisfaction_rating"
    t.jsonb "school_info"
    t.string "rent_url"
    t.float "pet_percentage"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "messages", "users"
  add_foreign_key "messages", "wards"
  add_foreign_key "reviews", "users"
  add_foreign_key "reviews", "wards"
  add_foreign_key "user_wards", "users"
  add_foreign_key "user_wards", "wards"
end
