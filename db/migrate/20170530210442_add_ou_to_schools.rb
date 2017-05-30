class AddOuToSchools < ActiveRecord::Migration[5.0]
  def change
    add_column :schools, :ou_string, :string
  end
end
