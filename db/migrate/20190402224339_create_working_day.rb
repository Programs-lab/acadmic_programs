class CreateWorkingDay < ActiveRecord::Migration[5.2]
  def change
    create_table :working_days do |t|
      t.references :working_weeks, null: false, foreign_key: true
      t.date :working_date, null: false
      t.timestamps
    end
  end
end
