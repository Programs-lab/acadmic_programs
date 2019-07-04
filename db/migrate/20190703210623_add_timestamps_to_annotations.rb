class AddTimestampsToAnnotations < ActiveRecord::Migration[5.2]
  def change
    add_column :appointment_report_annotations, :created_at, :datetime, null: false
    add_column :appointment_report_annotations, :updated_at, :datetime, null: false
  end
end
