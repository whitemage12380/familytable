class FamiliesUniqueNameConstraint < ActiveRecord::Migration[5.1]
  def change
    add_index(:families, :unique_name, unique: true)
  end
end
