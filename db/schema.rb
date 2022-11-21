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

ActiveRecord::Schema.define(version: 2022_11_18_040509) do

  create_table "account_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "account_id"
  end

  create_table "accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "org_name"
    t.string "country"
    t.string "street_address_1"
    t.string "street_address_2"
    t.string "city"
    t.string "province_or_state"
    t.string "postal_or_zip_code"
    t.string "profession"
    t.string "phone_business"
    t.string "phone_mobile"
    t.string "fax"
    t.string "email"
    t.string "time_zone"
    t.boolean "auto_dst_adjustment"
    t.string "currency_code"
    t.string "currency_symbol"
    t.string "admin_first_name"
    t.string "admin_last_name"
    t.string "admin_email"
    t.decimal "admin_billing_rate_per_hour", precision: 10
    t.string "admin_user_name"
    t.string "admin_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_additional_contacts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_billing_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_contacts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "client_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "home_phone"
    t.string "mobile_number"
    t.string "archive_number"
    t.datetime "archived_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "organization_name"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "home_phone"
    t.string "mobile_number"
    t.string "send_invoice_by"
    t.string "country"
    t.string "address_street1"
    t.string "address_street2"
    t.string "city"
    t.string "province_state"
    t.string "postal_zip_code"
    t.string "industry"
    t.string "company_size"
    t.string "business_phone"
    t.string "fax"
    t.text "internal_notes"
    t.string "archive_number"
    t.datetime "archived_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "available_credit", precision: 8, scale: 2, default: "0.0"
  end

end
