class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.boolean :blended_learning
      t.string :school_code

      t.timestamps
    end
  end
end
