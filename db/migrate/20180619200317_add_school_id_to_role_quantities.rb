class AddSchoolIdToRoleQuantities < ActiveRecord::Migration[5.0]
  def change
    add_reference :role_quantities, :school, index: true
  end
end
