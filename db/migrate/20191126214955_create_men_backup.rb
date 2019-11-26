class CreateMenBackup < ActiveRecord::Migration[5.2]
  def change
    create_table :men_backups do |t|
      t.string :resolution
      t.date :men_date
      t.references :processes_academic_program, foreign_key: true
    end
  end
end
