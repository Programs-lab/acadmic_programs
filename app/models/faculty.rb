class Faculty < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_general_information, against: [:name, :code]
  has_many :academic_programs, dependent: :destroy
  has_many :academic_departments, dependent: :destroy
end
