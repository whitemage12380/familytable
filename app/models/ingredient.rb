class Ingredient < ApplicationRecord
  has_many :family_dish_ingredients
  has_many :family_dishes, through: :family_dish_ingredients
end
