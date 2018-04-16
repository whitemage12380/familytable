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

ActiveRecord::Schema.define(version: 20180310215241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "families", force: :cascade do |t|
    t.text "unique_name", null: false
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_name"], name: "index_families_on_unique_name", unique: true
  end

  create_table "family_dishes", force: :cascade do |t|
    t.integer "parent_id"
    t.bigint "family_id", null: false
    t.text "name", null: false
    t.text "description"
    t.boolean "is_favorite", default: false, null: false
    t.integer "comfort_level", limit: 2
    t.integer "health_level", limit: 2
    t.integer "cooking_difficulty", limit: 2
    t.boolean "is_prepared_ahead"
    t.integer "prep_time_minutes"
    t.integer "cooking_time_minutes"
    t.text "serving_size"
    t.integer "protein_grams"
    t.integer "calories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_family_dishes_on_family_id"
  end

  create_table "family_members", force: :cascade do |t|
    t.integer "family_id", null: false
    t.integer "user_id"
    t.text "first_name", null: false
    t.text "last_name"
    t.date "birth_date", null: false
    t.boolean "is_guest", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "username", default: "", null: false
    t.text "email", default: "", null: false
    t.text "encrypted_password", default: "", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.text "display_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "default_family_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_copy", id: false, force: :cascade do |t|
    t.bigint "id", null: false
    t.text "username", null: false
    t.text "email", null: false
    t.text "encrypted_password", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.text "display_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "family_dishes", "families"
  add_foreign_key "family_dishes", "family_dishes", column: "parent_id"
  add_foreign_key "family_members", "families"
  add_foreign_key "family_members", "users"
  add_foreign_key "users", "families", column: "default_family_id"
end
