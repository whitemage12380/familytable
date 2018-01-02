class CreateFamilies < ActiveRecord::Migration[5.1]
  def change
    create_table :families do |t|
      t.string :unique_name, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
