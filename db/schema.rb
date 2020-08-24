# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_23_040736) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "status", default: 0
    t.bigint "venue_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "venue_sku"
    t.string "checkout_session_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
    t.index ["venue_id"], name: "index_bookings_on_venue_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.bigint "venue_id", null: false
    t.integer "hour_price_cents", default: 0, null: false
    t.string "hour_price_currency", default: "CHF", null: false
    t.integer "day_price_cents", default: 0, null: false
    t.string "day_price_currency", default: "CHF", null: false
    t.string "min_time"
    t.string "max_time"
    t.string "day_discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["venue_id"], name: "index_calendars_on_venue_id"
  end

  create_table "chat_boxes", force: :cascade do |t|
    t.string "name"
    t.bigint "booking_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_chat_boxes_on_booking_id"
  end

  create_table "days", force: :cascade do |t|
    t.bigint "calendar_id", null: false
    t.integer "month"
    t.integer "year"
    t.integer "wday"
    t.integer "hour_price_cents", default: 0, null: false
    t.string "hour_price_currency", default: "CHF", null: false
    t.integer "day_price_cents", default: 0, null: false
    t.string "day_price_currency", default: "CHF", null: false
    t.string "min_time"
    t.string "max_time"
    t.datetime "date"
    t.integer "day"
    t.integer "wnum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["calendar_id"], name: "index_days_on_calendar_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "chat_box_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_box_id"], name: "index_messages_on_chat_box_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "booking_id", null: false
    t.float "rating"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reviewable_type", null: false
    t.bigint "reviewable_id", null: false
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.integer "role"
    t.string "authentication_token", limit: 30
    t.string "provider"
    t.string "uid"
    t.string "full_name"
    t.float "rating"
    t.string "facebook_picture_url"
    t.string "token"
    t.datetime "token_expiry"
    t.string "access_code"
    t.string "publishable_key"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venue_specs", force: :cascade do |t|
    t.bigint "venue_id", null: false
    t.float "total_area"
    t.integer "spaces"
    t.integer "bathrooms"
    t.integer "garage_spaces"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["venue_id"], name: "index_venue_specs_on_venue_id"
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.bigint "user_id", null: false
    t.string "category"
    t.text "description"
    t.integer "capacity"
    t.string "activity"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "perks"
    t.integer "price_cents", default: 0, null: false
    t.string "sku"
    t.string "zone"
    t.boolean "published", default: false
    t.index ["user_id"], name: "index_venues_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "users"
  add_foreign_key "bookings", "venues"
  add_foreign_key "calendars", "venues"
  add_foreign_key "chat_boxes", "bookings"
  add_foreign_key "days", "calendars"
  add_foreign_key "messages", "chat_boxes"
  add_foreign_key "messages", "users"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "users"
  add_foreign_key "venue_specs", "venues"
  add_foreign_key "venues", "users"
end
