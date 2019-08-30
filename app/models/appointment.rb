class Appointment < ApplicationRecord
  include PgSearch

  pg_search_scope :search_by_details, associated_against:{
    doctor: [:first_name, :last_name, :id_number],
    patient: [:first_name, :last_name, :id_number],
  } 
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
  belongs_to :procedure_type
  has_one :appointment_report
  validate :available_appointment_hour, on: :create
  validate :scheduled_appointment_is_valid?
  enum state: [:disabled, :pending, :completed, :canceled, :attended]
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

  def scheduled_appointment_is_valid?
    working_week = doctor.doctor_working_weeks.between_date(appointment_datetime).first

    working_day = working_week ? working_week.working_days.find_by_working_date(appointment_datetime) : nil

    working_hour = working_day ? working_day.working_hours.between_datetime(appointment_datetime) : nil

    errors.add(:appointments,message: "The scheduled appointment is not valid.") unless appointment_datetime_is_valid?(working_hour.first)
  end

  def appointment_datetime_is_valid?(working_hour)
    return false unless working_hour
    
    initial_hour = DateTime.parse(working_hour.initial_hour.to_s)
    appointment_hour = DateTime.parse(appointment_datetime.to_s)
    difference_between_hours = (appointment_hour - initial_hour) * 1440
    valid_hour = difference_between_hours % procedure_type.procedure_duration == 0
    valid_hour = valid_hour && DateTime.now < appointment_datetime

    valid_hour
  end
end
