class AddAcademicDepartmentToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :academic_department, index: true    
  end
end
