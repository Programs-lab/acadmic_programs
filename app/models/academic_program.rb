class AcademicProgram < ApplicationRecord
  belongs_to :faculty
  has_many :users
end
