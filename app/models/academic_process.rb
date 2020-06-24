class AcademicProcess < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_general_information, against: [:name]
  has_many :processes_academic_programs, dependent: :destroy
  has_many :documents
  accepts_nested_attributes_for :documents, reject_if: :all_blank,  allow_destroy: true
  after_create :apply_to_all_programs
  validates :name, presence: true

  def apply_to_all_programs
    if AcademicProgram.any?
      AcademicProgram.all.each do |ap|
        ap.processes_academic_programs.create(academic_process_id: self.id)
        if ap.users.last
          ap.users.last.notifications.create(
          title: "Nuevo processo",
          message: "El programa academico tiene un nuevo proceso de nombre: #{self.name}",
          launch: Rails.application.routes.url_helpers.faculty_academic_program_process_academic_programs_path(
            faculty_id: ap.faculty.id,
            academic_program_id: ap.id
            )
          )
        end
        director = ap.users.last
        if director
          NotificationsMailer.new_notification(director.id, director.notifications.last.id).deliver_now()
        end
      end
    end
  end
end
