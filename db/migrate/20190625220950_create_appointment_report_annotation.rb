class CreateAppointmentReportAnnotation < ActiveRecord::Migration[5.2]
  def change
    create_table :appointment_report_annotations do |t|
      t.references :appointment_reports
      t.text :content
    end
  end
end
