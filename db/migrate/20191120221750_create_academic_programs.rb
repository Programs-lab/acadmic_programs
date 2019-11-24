class CreateAcademicPrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :academic_programs do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :email
      t.references :faculty, null: false, foreign_key: true
      t.timestamps
    end
  end
end
