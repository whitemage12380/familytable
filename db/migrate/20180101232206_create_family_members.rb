class CreateFamilyMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :family_members do |t|
      t.integer :family_id, null: false
      t.integer :user_id
      t.string :first_name, null: false
      t.string :last_name
      t.date :birth_date, null: false
      t.boolean :is_guest, null: false, default: false

      t.timestamps null: false
    end

    add_foreign_key :family_members, :families
    add_foreign_key :family_members, :users
  end
end
