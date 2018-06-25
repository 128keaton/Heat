class AddLocationIdToMachine < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :location, :integer
  end
end
