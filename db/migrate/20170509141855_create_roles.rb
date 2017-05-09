class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.json :specs
      t.string :suffix

      t.timestamps
    end
  end
end
