class FamilyMemberDish < ApplicationRecord
  belongs_to :family_member
  belongs_to :family_dish
end
