class AcademicProcess < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_general_information, against: [:name]
  has_many :processes_academic_programs, dependent: :destroy
  after_create :apply_to_all_programs

  def apply_to_all_programs
    if AcademicProgram.any
      AcademicProgram.all.each do |ap|
        ap.processes_academic_programs.create(academic_process_id: self.id)
      end  
    end
    
  end


end
