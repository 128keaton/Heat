class CreateMachines < ActiveRecord::Migration[5.0]
  def change
    create_table :machines do |t|
      t.string :serial_number
      t.string :client_asset_tag
      t.string :reviveit_asset_tag
      t.json :unboxed
      t.json :imaged
      t.json :racked
      t.json :deployed
      t.string :notes
      t.string :role
      t.string :rack
      t.boolean :doa
      t.json :special_instructions

      t.timestamps
    end
  end
end
