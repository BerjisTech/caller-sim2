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

ActiveRecord::Schema[7.0].define(version: 2024_09_26_194338) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "media_streams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "stream_data"
    t.uuid "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_media_streams_on_profile_id"
  end

  create_table "profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "room_members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "is_admin"
    t.uuid "room_id", null: false
    t.uuid "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_room_members_on_profile_id"
    t.index ["room_id"], name: "index_room_members_on_room_id"
  end

  create_table "room_message_reactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reaction"
    t.uuid "room_message_id", null: false
    t.uuid "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_room_message_reactions_on_profile_id"
    t.index ["room_message_id"], name: "index_room_message_reactions_on_room_message_id"
  end

  create_table "room_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.boolean "is_edited"
    t.boolean "is_deleted"
    t.uuid "room_id", null: false
    t.uuid "profile_id", null: false
    t.integer "reply_to_id"
    t.integer "quoted_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_room_messages_on_profile_id"
    t.index ["room_id"], name: "index_room_messages_on_room_id"
  end

  create_table "rooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "seats"
    t.boolean "is_private"
    t.string "password"
    t.boolean "is_active"
    t.string "tags", default: [], array: true
    t.uuid "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_rooms_on_profile_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", default: -> { "gen_random_uuid()" }, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "role", default: "user"
    t.boolean "is_active", default: true
    t.boolean "is_deleted", default: false
    t.datetime "deleted_at"
    t.datetime "last_login_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
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
