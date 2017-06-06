class AddTeacherOuToSchools < ActiveRecord::Migration[5.0]
  def change
    add_column :schools, :teacher_ou, :string
  end
end
