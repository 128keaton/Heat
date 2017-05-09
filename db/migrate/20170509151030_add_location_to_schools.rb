class AddLocationToSchools < ActiveRecord::Migration[5.0]
  def change
    add_column :schools, :location, :string
  end
end
