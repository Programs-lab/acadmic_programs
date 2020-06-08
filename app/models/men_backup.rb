class MenBackup < ApplicationRecord
  belongs_to :processes_academic_program
  validates  :resolution, uniqueness: true
end
