class Family < ActiveRecord::Base
  # attr_accessible :name, :unique_name
  has_many :family_members
  accepts_nested_attributes_for :family_members
end
