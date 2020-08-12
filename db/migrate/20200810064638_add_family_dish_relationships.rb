class AddFamilyDishRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :family_member_dishes do |t|
      t.references :family, index: true, foreign_key: true, null: false
      t.references :family_member, index: true, foreign_key: true, null: false
      t.references :family_dish, index: true, foreign_key: true, null: false
      t.boolean :is_favorite, default: false, null: false
      t.integer :comfort_level, limit: 1
      t.integer :enjoyment_level, limit: 1
      t.integer :cooking_ability_level, limit: 1
      t.string :note
      t.timestamps null: false
    end
  end
end
