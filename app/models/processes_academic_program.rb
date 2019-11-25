class ProcessesAcademicProgram < ApplicationRecord
  belongs_to :academic_process
  belongs_to :academic_program
  has_many :media
end
