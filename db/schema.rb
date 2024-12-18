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

ActiveRecord::Schema[8.0].define(version: 2024_12_15_232331) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "clear_missions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date", null: false
    t.integer "completed_missions_count", default: 0, null: false
    t.integer "total_points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "date"], name: "index_clear_missions_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_clear_missions_on_user_id"
  end

  create_table "early_rises", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "wake_up_time", null: false
    t.datetime "cleared_at"
    t.string "status", default: "未設定", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_early_rises_on_user_id"
  end

  create_table "friends", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friends_on_friend_id"
    t.index ["user_id"], name: "index_friends_on_user_id"
  end

  create_table "points", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount", null: false
    t.datetime "granted_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "value"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wake_up_times", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "wake_up_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wake_up_times_on_user_id"
  end

  add_foreign_key "articles", "users"
  add_foreign_key "clear_missions", "users"
  add_foreign_key "early_rises", "users"
  add_foreign_key "friends", "users"
  add_foreign_key "friends", "users", column: "friend_id"
  add_foreign_key "points", "users"
  add_foreign_key "tokens", "users"
end
