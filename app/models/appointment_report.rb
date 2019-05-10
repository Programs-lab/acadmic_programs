class AppointmentReport < ApplicationRecord
  belongs_to :appointment, optional: true
  belongs_to :medical_record
  has_many   :appointments
end
