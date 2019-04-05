class WorkingWeek < ApplicationRecord
  has_many :working_days
  belongs_to :doctor, class_name: "User", foreign_key: "doctor_id"
end
