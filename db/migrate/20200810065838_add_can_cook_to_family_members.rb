class AddCanCookToFamilyMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :family_members, :can_cook, :boolean, default: true, null: false
  end
end
