class AddFormFactorIdToMachines < ActiveRecord::Migration[5.0]
  def change
    add_reference :machines, :form_factor, index: true
  end
end
