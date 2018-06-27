class CreateFormFactors < ActiveRecord::Migration[5.0]
  def change
    create_table :form_factors do |t|
      t.string :name
      t.string :type
      t.timestamps
    end
  end
end
