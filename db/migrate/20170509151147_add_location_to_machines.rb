class AddLocationToMachines < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :location, :string
  end
end
