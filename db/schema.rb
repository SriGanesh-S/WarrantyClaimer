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

ActiveRecord::Schema.define(version: 2023_04_19_041727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "door_no"
    t.string "street"
    t.string "district"
    t.string "state"
    t.integer "pin_code"
    t.bigint "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "addressable_type"
    t.integer "addressable_id"
  end

  create_table "claim_statuses", force: :cascade do |t|
    t.bigint "warranty_claim_id", null: false
    t.string "status"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["warranty_claim_id"], name: "index_claim_statuses_on_warranty_claim_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customers_sellers", id: false, force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "seller_id", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "purcharse_date"
    t.integer "seller_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sellers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "warranty_claims", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "product_id", null: false
    t.text "problem_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_warranty_claims_on_customer_id"
    t.index ["product_id"], name: "index_warranty_claims_on_product_id"
  end

  add_foreign_key "claim_statuses", "warranty_claims"
  add_foreign_key "warranty_claims", "customers"
  add_foreign_key "warranty_claims", "products"
end
