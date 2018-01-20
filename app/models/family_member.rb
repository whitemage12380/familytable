class FamilyMember < ActiveRecord::Base
  #attr_accessible :family_id, :user_id, :first_name, :last_name, :birth_date
  belongs_to :user
  belongs_to :family
end
