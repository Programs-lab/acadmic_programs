class WorkingHour < ApplicationRecord
  belongs_to :working_day
  belongs_to :procedure_type
  validate :is_updatable
  validate :hourLImitsMakeSense

  def is_updatable
     appointments = Appointment.where(appointment_datetime: self.initial_hour_was..self.end_hour_was)
     if (appointments.any?)
      errors.add(:working_hours, 'hay citas asignadas en este horario')
     end
  end

  def hourLImitsMakeSense
    if (self.initial_hour > self.end_hour)
      errors.add(:working_hours, 'las horas de inicio y fin no son coherentes')
    end
  end
end
