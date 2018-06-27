class AddIsSchoolToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :is_school, :boolean
  end
end
