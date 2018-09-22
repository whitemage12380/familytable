class AddUniqueConstraintToFamilyDishIngredients < ActiveRecord::Migration[5.1]
  def change
    add_index(:family_dish_ingredients, [:family_dish_id, :ingredient_id], unique: true, name: "index_family_dish_ingredients_unique_join_cols")
  end
end
