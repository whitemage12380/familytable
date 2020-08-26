class AddUniqueKeyToFamilyMemberDishes < ActiveRecord::Migration[5.2]
  def change
    add_index :family_member_dishes, [:family_member_id, :family_dish_id], unique: true, name: 'index_family_member_dishes_unique'
  end
end
