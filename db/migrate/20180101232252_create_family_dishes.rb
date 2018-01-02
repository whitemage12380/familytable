class CreateFamilyDishes < ActiveRecord::Migration[5.1]
  def change
    create_table :family_dishes do |t|
      t.integer :parent_id
      t.references :family, index: true, foreign_key: true, null: false
      t.string :name, null: false
      t.string :description
      t.boolean :is_favorite, default: false, null: false
      t.integer :comfort_level, limit: 1
      t.integer :health_level, limit: 1
      t.integer :cooking_difficulty, limit: 1
      t.boolean :is_prepared_ahead
      t.integer :prep_time_minutes
      t.integer :cooking_time_minutes
      t.string :serving_size
      t.integer :protein_grams
      t.integer :calories
      t.timestamps null: false
    end
    add_foreign_key :family_dishes, :family_dishes, column: 'parent_id'
  end
end
