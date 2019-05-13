class AddIndexToAppointmentReport < ActiveRecord::Migration[5.2]
  def change
    add_column :appointment_reports, :doctor_id, :bigint, null: false, index: true
  end
end
