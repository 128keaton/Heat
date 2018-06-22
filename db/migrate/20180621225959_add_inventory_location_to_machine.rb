class AddInventoryLocationToMachine < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :inventory_location, :string
  end
end
