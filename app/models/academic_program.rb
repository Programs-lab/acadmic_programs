class AcademicProgram < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_general_information, against: [:name, :code]
  belongs_to :faculty
  has_many :users
end
