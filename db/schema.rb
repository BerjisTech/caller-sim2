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

ActiveRecord::Schema[7.0].define(version: 2024_09_26_191701) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "media_streams", force: :cascade do |t|
    t.text "stream_data"
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_media_streams_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "user_id"
    t.boolean "is_anonymous"
    t.boolean "is_authenticated"
    t.boolean "is_superuser"
    t.boolean "is_staff"
    t.string "username"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "full_name"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_members", force: :cascade do |t|
    t.boolean "is_admin"
    t.bigint "room_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_room_members_on_profile_id"
    t.index ["room_id"], name: "index_room_members_on_room_id"
  end

  create_table "room_message_reactions", force: :cascade do |t|
    t.string "reaction"
    t.bigint "room_message_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_room_message_reactions_on_profile_id"
    t.index ["room_message_id"], name: "index_room_message_reactions_on_room_message_id"
  end

  create_table "room_messages", force: :cascade do |t|
    t.text "content"
    t.boolean "is_edited"
    t.boolean "is_deleted"
    t.bigint "room_id", null: false
    t.bigint "profile_id", null: false
    t.integer "reply_to_id"
    t.integer "quoted_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_room_messages_on_profile_id"
    t.index ["room_id"], name: "index_room_messages_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "seats"
    t.boolean "is_private"
    t.string "password"
    t.boolean "is_active"
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_rooms_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "media_streams", "profiles"
  add_foreign_key "room_members", "profiles"
  add_foreign_key "room_members", "rooms"
  add_foreign_key "room_message_reactions", "profiles"
  add_foreign_key "room_message_reactions", "room_messages"
  add_foreign_key "room_messages", "profiles"
  add_foreign_key "room_messages", "rooms"
  add_foreign_key "rooms", "profiles"
end
