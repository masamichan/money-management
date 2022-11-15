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

ActiveRecord::Schema.define(version: 2022_11_15_014259) do

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
    t.decimal "admin_billing_rate_per_hour", precision: 10, scale: 10
    t.string "admin_user_name"
    t.string "admin_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "update_at", null: false
  end

  create_table "client_additional_contacts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_billing_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
