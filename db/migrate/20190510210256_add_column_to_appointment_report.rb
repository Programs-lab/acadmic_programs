class AddColumnToAppointmentReport < ActiveRecord::Migration[5.2]
  def change
    add_column :appointment_reports, :appointment_datetime, :datetime, null: false
  end
end
