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

ActiveRecord::Schema.define(version: 2019_11_20_224646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_departments", force: :cascade do |t|
    t.bigint "faculties_id", null: false
    t.string "code", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faculties_id"], name: "index_academic_departments_on_faculties_id"
  end

  create_table "academic_programs", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "email"
    t.bigint "faculties_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faculties_id"], name: "index_academic_programs_on_faculties_id"
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

  create_table "faculties", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", force: :cascade do |t|
    t.string "file_name"
    t.bigint "processes_academic_programs_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["processes_academic_programs_id"], name: "index_media_on_processes_academic_programs_id"
  end

  create_table "processes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "year_saces"
    t.integer "month_saces"
    t.integer "day_saces"
    t.integer "year_academic_council"
    t.integer "month_academic_council"
    t.integer "day_academic_council"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "processes_academic_programs", force: :cascade do |t|
    t.date "men_date"
    t.integer "validity"
    t.date "expiration_date"
    t.date "saces_date"
    t.date "academic_council_date"
    t.bigint "academic_programs_id"
    t.bigint "processes_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["academic_programs_id"], name: "index_processes_academic_programs_on_academic_programs_id"
    t.index ["processes_id"], name: "index_processes_academic_programs_on_processes_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "birthdate"
    t.string "id_type"
    t.string "id_number", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.boolean "disabled", default: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "avatar"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "academic_departments", "faculties", column: "faculties_id"
  add_foreign_key "academic_programs", "faculties", column: "faculties_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "media", "processes_academic_programs", column: "processes_academic_programs_id"
  add_foreign_key "processes_academic_programs", "academic_programs", column: "academic_programs_id"
  add_foreign_key "processes_academic_programs", "processes", column: "processes_id"
end
