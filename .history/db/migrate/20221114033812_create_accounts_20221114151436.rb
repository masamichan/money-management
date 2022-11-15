class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string   "org_name"
      t.string   "country"
      t.string      
    end
  end
end
