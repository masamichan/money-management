class CreateCompanyEmailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :company_email_templates do |t|

      t.timestamps
    end
  end
end
