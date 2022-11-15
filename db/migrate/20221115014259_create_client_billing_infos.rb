class CreateClientBillingInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :client_billing_infos do |t|

      t.timestamps
    end
  end
end
