class CreateWorkingWeek < ActiveRecord::Migration[5.2]
  def change
    create_table :working_weeks do |t|
      t.references :doctor, references: :users, null: false
      t.date :initial_date, null: false
      t.date :end_date, null: false
      t.timestamps
    end
  end
end
