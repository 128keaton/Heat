class AddLocationToRackCart < ActiveRecord::Migration[5.0]
  def change
    add_column :rack_carts, :location, :string
  end
end
