class AddLocationIdToMachine < ActiveRecord::Migration[5.0]
  def change
    add_reference :machines, :location, index: true
  end
end
