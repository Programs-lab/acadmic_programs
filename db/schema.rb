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

ActiveRecord::Schema.define(version: 2019_05_13_212731) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "appointment_reports", force: :cascade do |t|
    t.bigint "appointment_id"
    t.bigint "medical_record_id", null: false
    t.text "diagnosis"
    t.text "medical_order"
    t.text "medical_disability"
    t.text "reference"
    t.text "examination_request"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "appointment_datetime", null: false
    t.bigint "doctor_id", null: false
    t.index ["appointment_id"], name: "index_appointment_reports_on_appointment_id"
    t.index ["medical_record_id"], name: "index_appointment_reports_on_medical_record_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "doctor_id", null: false
    t.datetime "appointment_datetime"
    t.bigint "procedure_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disabled", default: false, null: false
    t.boolean "attended", default: false, null: false
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["procedure_type_id"], name: "index_appointments_on_procedure_type_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "company_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id", null: false
  end

  create_table "medical_records", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_medical_records_on_patient_id"
  end

  create_table "procedure_companies", force: :cascade do |t|
    t.decimal "cost", default: "0.0", null: false
    t.bigint "company_id", null: false
    t.bigint "procedure_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_procedure_companies_on_company_id"
    t.index ["procedure_type_id"], name: "index_procedure_companies_on_procedure_type_id"
  end

  create_table "procedure_types", force: :cascade do |t|
    t.string "procedure_type_name", null: false
    t.decimal "cost", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "procedure_duration", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "birthdate"
    t.string "id_type"
    t.string "id_number", null: false
    t.string "address"
    t.string "phone_number"
    t.string "occupation"
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
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "working_days", force: :cascade do |t|
    t.bigint "working_week_id", null: false
    t.date "working_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["working_week_id"], name: "index_working_days_on_working_week_id"
  end

  create_table "working_hours", force: :cascade do |t|
    t.bigint "working_day_id", null: false
    t.datetime "initial_hour", null: false
    t.datetime "end_hour", null: false
    t.boolean "remember", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "procedure_type_id", null: false
    t.index ["procedure_type_id"], name: "index_working_hours_on_procedure_type_id"
    t.index ["working_day_id"], name: "index_working_hours_on_working_day_id"
  end

  create_table "working_weeks", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.date "initial_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_working_weeks_on_doctor_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointment_reports", "appointments"
  add_foreign_key "appointment_reports", "medical_records"
  add_foreign_key "appointments", "procedure_types"
  add_foreign_key "procedure_companies", "companies"
  add_foreign_key "procedure_companies", "procedure_types"
  add_foreign_key "working_days", "working_weeks"
  add_foreign_key "working_hours", "working_days"
end
