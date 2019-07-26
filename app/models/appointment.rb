class Appointment < ApplicationRecord
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
  belongs_to :procedure_type
  validate :available_appointment_hour, on: :create
  validate :appointment_hour_is_valid?
  validate :datetime_between_working_hour?
  enum state: [:disabled, :pending, :completed, :canceled]
  before_create :set_default_state
  before_create :set_appointment_price


  private


  def set_default_state
    self.state ||= :pending
  end

  def set_appointment_price
    if self.patient.company
      procedure_company = ProcedureCompany.where(company_id: self.patient.company.id, procedure_type_id: self.procedure_type.id)
      if procedure_company.any?
        self.appointment_price = procedure_company.first.cost
      end
    else
      self.appointment_price = self.procedure_type.cost
    end
  end

  def available_appointment_hour
    appointments_any = Appointment.where(appointment_datetime: appointment_datetime).where(state: :pending).or(Appointment.where(appointment_datetime: appointment_datetime).where(state: :disabled)).any?

    errors.add(:appointments, message: "there are not available appointments for this hour") if appointments_any
  end

  def appointment_hour_is_valid?
    valid_hour = DateTime.parse(appointment_datetime.to_s).minute % procedure_type.procedure_duration == 0
    valid_hour = valid_hour && DateTime.now < appointment_datetime

    errors.add(:appointments, message: "The appointment hour is not valid.") unless valid_hour
  end

  def datetime_between_working_hour?
    working_week = doctor.doctor_working_weeks.between_date(appointment_datetime).first

    working_day = working_week ? working_week.working_days.find_by_working_date(appointment_datetime) : nil

    working_hour = working_day ? working_day.working_hours.between_datetime(appointment_datetime) : nil

    errors.add(:appointments, message: "The doctor is not available at #{appointment_datetime}") unless working_hour.present?
  end
end
