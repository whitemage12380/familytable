class AddDefaultFamilyToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :default_family_id , :bigint
    add_foreign_key :users, :families, column: :default_family_id
  end
end
