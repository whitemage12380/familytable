class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.integer :parent_id
      t.references :family, index: true, foreign_key: true
      t.string :name, null: false
      t.boolean :is_basic, default: true, null: false
      t.boolean :is_public, default: true, null: false
      t.string :serving_size
      t.integer :calories
      t.integer :protein_grams

      t.timestamps
    end
    add_foreign_key :ingredients, :ingredients, column: 'parent_id'
    add_index :ingredients, :name, unique: true
  end
end
