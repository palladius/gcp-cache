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

ActiveRecord::Schema[7.0].define(version: 2023_07_20_194219) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billing_accounts", force: :cascade do |t|
    t.text "description"
    t.string "display_name"
    t.string "master_billing_account"
    t.string "name"
    t.boolean "open"
    t.string "baid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.string "frog_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
  end

  create_table "inventory_items", force: :cascade do |t|
    t.text "serialized_ancestors"
    t.text "description"
    t.string "asset_type"
    t.string "name"
    t.datetime "gcp_update_time", precision: nil
    t.string "resource_location"
    t.string "resource_discovery_name"
    t.string "resource_parent"
    t.string "project"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labels", force: :cascade do |t|
    t.string "gcp_k"
    t.string "gcp_val"
    t.string "labellable_type"
    t.bigint "labellable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["labellable_type", "labellable_id"], name: "index_labels_on_labellable"
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

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "gcp_tag"
    t.integer "priority"
    t.string "expected_status"
    t.string "devconsole_url"
    t.bigint "inventory_item_id", null: false
    t.text "description"
    t.text "internal_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_item_id"], name: "index_services_on_inventory_item_id"
  end

  create_table "vms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "internal_notes"
    t.string "machine_type"
    t.string "internal_ip"
    t.string "external_ip"
    t.string "self_link"
    t.string "zone"
    t.integer "disk1_size_gb"
    t.string "disk1_name"
    t.string "status"
    t.boolean "is_preemptible"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_vms_on_project_id"
  end

  add_foreign_key "services", "inventory_items"
  add_foreign_key "vms", "projects"
end
