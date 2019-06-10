class DoctorProcedureType < ApplicationRecord
  belongs_to :procedure_type
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
end
