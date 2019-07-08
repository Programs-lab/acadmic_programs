class AppointmentReport < ApplicationRecord
  belongs_to :appointment, optional: true
  belongs_to :medical_record
  has_many :appointment_report_annotations
  #has_many   :appointments
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
  after_create :attended_appointment
  accepts_nested_attributes_for :appointment_report_annotations, reject_if: :all_blank, allow_destroy: true

  def attended_appointment
    self.appointment.update(state: :completed) if self.appointment
  end
end
