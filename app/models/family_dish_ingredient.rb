class FamilyDishIngredient < ApplicationRecord
  self.primary_keys = :family_dish_id, :ingredient_id
  belongs_to :family_dish
  belongs_to :ingredient
end
