class Appointment < ApplicationRecord
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
  belongs_to :procedure_type
  validate :is_valid_record, on: :create
  enum state: [:disabled, :pending, :completed, :canceled]
  before_create :set_default_state
  before_create :set_appointment_price


  private


  def set_default_state
    self.state ||= :pending
  end

  def set_appointment_price
    if self.patient.company
      procedure_company = ProcedureCpmany.where(company_id: self.patient.company.id, procedure_type_id: self.procedure_type.id)
      if procedure_company.any?
        self.appointment_price = procedure_company.first.cost
      end
    else
      self.appointment_price = self.procedure_type.cost
    end     
  end

  def is_valid_record
    appointment_datetime = self.appointment_datetime
    appointments_any = Appointment.where(appointment_datetime: appointment_datetime).where(state: :pending).or(Appointment.where(state: :disabled)).any?
    datetime_between_working_hour = WorkingHour.where('initial_hour <= :date AND end_hour > :date', date: appointment_datetime).any?

    if appointments_any || !datetime_between_working_hour || DateTime.now >= appointment_datetime
      errors.add(:appointments, message: "there are not available appointments for this hour")
    end
  end
end
