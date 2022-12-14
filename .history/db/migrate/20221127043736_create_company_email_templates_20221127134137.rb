class CreateCompanyEmailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :company_email_templates do |t|
      t.integer   "template_id"
      t.integer   "parent_id"
      t.string    "parent_type"
      t.datetime   "created_at", null: false
      t.datetime   "update_at", null: false
    end
  end
end
