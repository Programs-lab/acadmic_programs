class CreateWorkingHour < ActiveRecord::Migration[5.2]
  def change
    create_table :working_hours do |t|
      t.references :working_days, null: false, foreign_key: true
      t.datetime :initial_hour, null: false
      t.datetime :end_hour, null: false
      t.boolean :remember, null: false, default: true
      t.timestamps
    end
  end
end
