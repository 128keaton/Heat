class AddProductToRole < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :product, :string
  end
end
