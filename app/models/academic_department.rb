class AcademicDepartment < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_general_information, against: [:code]
  belongs_to :faculty
  has_many :users
end
