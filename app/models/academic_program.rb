class AcademicProgram < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_general_information, against: [:name, :code]
  belongs_to :faculty
  has_many :processes_academic_programs, dependent: :destroy
  has_many :users
  after_create :create_processes


  def create_processes
    if Process.any
      Process.all.each do |p|
        self.processes_academic_programs.create(academic_process_id: p.id)
      end  
    end
    
  end
end
