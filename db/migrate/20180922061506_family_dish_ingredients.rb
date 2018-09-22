class FamilyDishIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :family_dish_ingredients do |t|
      t.references :family_dish, index: true, foreign_key: true, null: false
      t.references :ingredient, index: true, foreign_key: true, null: false
      t.string :relationship, null: false, default: "primary"

      t.timestamps null: false
    end
  end
end
