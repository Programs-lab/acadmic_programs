class Appointment < ApplicationRecord
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
  belongs_to :procedure_type
  validate :is_valid_record, on: :create


  private

  def is_valid_record
    appointment_datetime = self.appointment_datetime
    appointments_any = Appointment.where(appointment_datetime: appointment_datetime, attended: false, diabled: false).any?
    datetime_between_working_hour = WorkingHour.where('initial_hour <= :date AND end_hour > :date', date: appointment_datetime).any?
    if appointments_any || !datetime_between_working_hour || DateTime.now >= appointment_datetime
      errors.add(:appointments, message: "there are not available appointments for this hour")
    end
  end
end
