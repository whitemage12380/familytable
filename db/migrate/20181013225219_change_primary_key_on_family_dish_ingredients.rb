class ChangePrimaryKeyOnFamilyDishIngredients < ActiveRecord::Migration[5.1]
  def change
    reversible do |m|
      m.up do
        execute "ALTER TABLE familytable.family_dish_ingredients DROP CONSTRAINT family_dish_ingredients_pkey"
        execute "ALTER TABLE familytable.family_dish_ingredients ADD PRIMARY KEY (family_dish_id, ingredient_id)"
      end
      m.down do
        execute "ALTER TABLE familytable.family_dish_ingredients DROP CONSTRAINT family_dish_ingredients_pkey"
        execute "ALTER TABLE familytable.family_dish_ingredients ADD PRIMARY KEY (id)"
      end
    end

    remove_index :family_dish_ingredients, name: :index_family_dish_ingredients_unique_join_cols, unique: true, column: [:family_dish_id, :ingredient_id]

  end
end
