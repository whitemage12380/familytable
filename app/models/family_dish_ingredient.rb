class FamilyDishIngredient < ApplicationRecord
  belongs_to :family_dish
  belongs_to :ingredient
end
