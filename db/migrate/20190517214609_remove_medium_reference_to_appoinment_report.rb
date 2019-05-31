class RemoveMediumReferenceToAppoinmentReport < ActiveRecord::Migration[5.2]
  def change
    remove_reference :media, :appointment_report, index: true
    add_reference :media, :medical_record, index: true
  end
end
