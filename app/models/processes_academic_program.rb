class ProcessesAcademicProgram < ApplicationRecord
  belongs_to :process
  belongs_to :academic_program
  has_many :media
end
