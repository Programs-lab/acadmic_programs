class AppointmentReport < ApplicationRecord
  belongs_to :appointment
  belongs_to :medical_record
  has_many   :appointments
end
