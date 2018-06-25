class AddLocationIdToRoleQuantities < ActiveRecord::Migration[5.0]
  def change
    add_reference :role_quantities, :location, index: true
  end
end
