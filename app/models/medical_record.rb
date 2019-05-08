class MedicalRecord < ApplicationRecord
  belongs_to :patient, class_name: "User", foreign_key: "patient_id"
  has_many :appointment_reports
end
