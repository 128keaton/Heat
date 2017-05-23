class CreateRackCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :rack_carts do |t|
      t.string :rack_id
      t.text :children
      t.boolean :full
      t.integer :capacity

      t.timestamps
    end
  end
end
