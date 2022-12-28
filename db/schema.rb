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

ActiveRecord::Schema[7.0].define(version: 2022_12_28_084949) do
  create_table "folders", force: :cascade do |t|
    t.string "name"
    t.string "folder_id"
    t.boolean "is_org"
    t.string "parent_id"
    t.text "description"
    t.string "domain"
    t.string "directory_customer_id"
    t.string "lifecycle_state"
    t.datetime "gcp_creation_time"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labels", force: :cascade do |t|
    t.string "gcp_key"
    t.string "gcp_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_id"
    t.string "project_number"
    t.string "organization_id"
    t.string "parent_id"
    t.string "billing_account_id"
    t.text "description"
    t.string "lifecycle_state"
    t.string "project_name"
    t.datetime "project_creation_time", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
