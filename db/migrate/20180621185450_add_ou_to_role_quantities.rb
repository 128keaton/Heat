class AddOuToRoleQuantities < ActiveRecord::Migration[5.0]
  def change
    add_column :role_quantities, :ou, :string
  end
end
