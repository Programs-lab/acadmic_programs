class CreateAppointment < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.references :patient, references: :users, null: false
      t.references :doctor, references: :users, null: false
      t.datetime :appointment_datetime
      t.references :procedure_type, null: false, foreign_key: true
      t.timestamps
    end
  end
end
