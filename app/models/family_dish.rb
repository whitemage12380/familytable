class FamilyDish < ActiveRecord::Base
  attr_accessible :parent_id, :family_id, :name, :description, :is_favorite, 
                  :comfort_level, :health_level, :cooking_difficulty, :is_prepared_ahead, 
                  :prep_time_minutes, :cooking_time_minutes, :serving_size, :protein_grams, :calories
  belongs_to :family
end
