class CreateProcessesAcademicPrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :processes_academic_programs do |t|
      t.date :men_date
      t.integer :validity
      t.date :expiration_date
      t.date :saces_date
      t.date :academic_council_date
      t.references :academic_program, foreign_key: true
      t.references :process, foreign_key: true
      t.timestamps
    end
  end
end
