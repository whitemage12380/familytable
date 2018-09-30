class FamilyDishIngredient < ApplicationRecord
  has_one :family_dish
  has_one :ingredient
end
