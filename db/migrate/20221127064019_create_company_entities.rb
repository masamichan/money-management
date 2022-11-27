class CreateCompanyEntities < ActiveRecord::Migration[6.0]
  def change
    create_table :company_entities do |t|

      t.timestamps
    end
  end
end
