class CreateProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :processes do |t|
      t.string :name, null: false
      t.integer :year_saces
      t.integer :month_saces
      t.integer :day_saces
      t.integer :year_academic_council
      t.integer :month_academic_council
      t.integer :day_academic_council
      t.timestamps
    end
  end
end
