class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string    "organazation_name"
      t.string    "email"
      t.string    "first_name"
      t.string    "last_name"
      t.string    "home_phone"
      t.string    "mobile_number"
      t.string    "send_invoice_by"
      t.string    "country"
      t.string    "address_street1"
      t.string    "address_street2"
      t.string    "city"
      t.string    "province_state"
      t.string    "postal_zip_code"
      t.string    "industry"
      t.string    "company_size"
      t.string    "business_phone"
      t.string    "fax"
      t.text      "internal_notes"
      t.string    "archive_namber"
      t.datetime  "archive_at"
      t.datetime  "deleted_at"
      t.datetime  "created_at", null: false
      t.datetime  "updated_at", null: false
      t.decimal   "availabel_credit", precision: 8, scale: 2, default: 0.0
    end
  end
end
