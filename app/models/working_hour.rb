class WorkingHour < ApplicationRecord
  belongs_to :working_day
  has_many :working_hours_procedure_types, dependent: :delete_all
  has_many :procedure_types, through: :working_hours_procedure_types
  validate :is_updatable
  validate :hour_limits_make_sense
  before_validation :assign_procedure_types
  scope :between_datetime, ->(date) { where('initial_hour <= :date AND end_hour > :date', date: date) }

  def is_updatable
     appointments = Appointment.where(appointment_datetime: self.initial_hour_was..self.end_hour_was, state: :pending, state: :disabled)
     if (appointments.any?)
      errors.add(:working_hours, 'hay citas asignadas en este horario')
     end
  end

  def assign_procedure_types
    procedure_types = self.working_day.working_week.doctor.procedure_types
    procedure_type_ids = []
    self.procedure_type_kinds.each do |pk|
      procedure_type_ids.push(procedure_types.where(kind: pk.to_sym).pluck(:id))
    end
    self.procedure_type_ids = procedure_type_ids.flatten
  end

  def hour_limits_make_sense
    if (self.initial_hour > self.end_hour)
      errors.add(:working_hours, 'las horas de inicio y fin no son coherentes')
    end
  end
end
