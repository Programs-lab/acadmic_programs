class DoctorProcedureType < ApplicationRecord
  belongs_to :procedure_type
  belongs_to :user, foreign_key: 'doctor_id'
end
