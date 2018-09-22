class RemoveFamilyDishIdIndexFromFamilyDishIngredients < ActiveRecord::Migration[5.1]
  def change
    remove_index :family_dish_ingredients, column: :family_dish_id
  end
end
