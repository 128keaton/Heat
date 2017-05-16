class AddPalletCountToRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :pallet_count, :int
    add_column :roles, :pallet_layer_count, :int
  end
end
