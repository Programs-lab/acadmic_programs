class CreateAppointmentReport < ActiveRecord::Migration[5.2]
  def change
    create_table :appointment_reports do |t|
      t.references :appointment, null: true, foreign_key: true
      t.references :medical_record, null: false, foreign_key: true
      t.text :diagnosis
      t.text :medical_order
      t.text :medical_disability
      t.text :reference
      t.text :examination_request
      t.timestamps
    end
  end
end
