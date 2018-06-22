class CreateRoleQuantities < ActiveRecord::Migration[5.0]
  def change
    create_table :role_quantities do |t|
      t.integer :quantity, :default => 0
      t.integer :max_quantity
      t.timestamps
    end
  end
end
