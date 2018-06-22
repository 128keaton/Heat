class AddRoleIdToRoleQuantities < ActiveRecord::Migration[5.0]
  def change
    add_reference :role_quantities, :role, index: false
  end
end
