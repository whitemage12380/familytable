class FamilyDish < ActiveRecord::Base
  #attr_accessible :parent_id, :family_id, :name, :description, :is_favorite, 
  #                :comfort_level, :health_level, :cooking_difficulty, :is_prepared_ahead, 
  #                :prep_time_minutes, :cooking_time_minutes, :serving_size, :protein_grams, :calories
  belongs_to :family
  has_many :family_dish_ingredients
  has_many :ingredients, through: :family_dish_ingredients
  has_many :family_member_dishes
  has_many :family_members, through: :family_member_dishes
  accepts_nested_attributes_for :family_dish_ingredients, allow_destroy: true
  accepts_nested_attributes_for :family_member_dishes, allow_destroy: true
end
