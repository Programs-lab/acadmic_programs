class CreateAcademicDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :academic_departments do |t|
      t.references :faculties, null: false, foreign_key: true
      t.string :code, null: false
      t.text :description 
      t.timestamps
    end
  end
end

