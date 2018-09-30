class AddVegetarianAndGlutenFreeToIngredients < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients, :vegetarian, :string
    add_column :ingredients, :vegan, :string
    add_column :ingredients, :gluten_free, :string
  end
end
