class CreateClientAdditionalContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :client_additional_contacts do |t|
      
      t.timestamps
    end
  end
end
