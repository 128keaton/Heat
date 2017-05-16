class AddPalletIdToMachine < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :pallet_id, :int
  end
end
