class AddModelNumberToMachines < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :model, :string, null: false, default: ''
  end
end
