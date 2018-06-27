class AddPoNumberToMachines < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :po_number, :string
  end
end
