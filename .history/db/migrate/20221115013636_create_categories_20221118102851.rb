class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string   "category"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
