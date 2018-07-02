class CreateModels < ActiveRecord::Migration[5.0]
  def change
    create_table :models do |t|
      t.string :first_match
      t.string :number

      t.timestamps
    end
  end
end
