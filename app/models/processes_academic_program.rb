class ProcessesAcademicProgram < ApplicationRecord
  belongs_to :academic_process
  belongs_to :academic_program
  has_many :procedures
  has_many :men_backups, dependent: :destroy
  before_update :calculate_dates
  before_update :save_backup
  has_many :media, dependent: :destroy
  validates :men_date, presence: true, on: :update
  validates :validity, presence: true, on: :update
  validates :resolution, presence: true, on: :update


  def calculate_dates
    self.expiration_date = self.men_date + self.validity.years
    self.saces_date = self.men_date + self.academic_process.year_saces.years + self.academic_process.month_saces.months + self.academic_process.day_saces.days
    self.academic_council_date = self.men_date + self.academic_process.year_academic_council.years + self.academic_process.month_academic_council.months + self.academic_process.day_academic_council.days
  end

  def save_backup
    if men_date_changed? && resolution_changed?
      self.men_backups.create(resolution: self.resolution, men_date: self.men_date)
      if self.academic_program.users.any?
      self.academic_program.users.last.notifications.create(
        title: "Nueva resolucion",
        message: "El proceso #{self.academic_process.name} obtuvo una nueva resolucion las fechas de vencimiento se han recalculado",
        launch: Rails.application.routes.url_helpers.faculty_academic_program_process_academic_program_procedures_path(
          faculty_id: self.academic_program.faculty.id,
          academic_program_id: self.academic_program.id,
          process_academic_program_id: self.id
          )
        )
        director = self.academic_program.users.last
        NotificationsMailer.new_notification(director.id, director.notifications.last.id).deliver_now()
      end
    end
  end

  def self.notify
    if (self.expiration_date - Date.today).numerator == 30  || (self.expiration_date - Date.today).numerator == 15 || (self.expiration_date - Date.today).numerator == 7
      if self.academic_program.users.any?
      self.academic_program.users.last.notifications.create(
        title: "Proceso proximo a vencer",
        message: "El proceso #{self.academic_process.name} se vencera en #{(self.expiration_date - Date.today).numerator} dias,  se aconseja que se tramite su renovacion prontamente",
        launch: Rails.application.routes.url_helpers.faculty_academic_program_process_academic_program_procedures_path(
          faculty_id: self.academic_program.faculty.id,
          academic_program_id: self.academic_program.id,
          process_academic_program_id: self.id
          )
        )
      director = self.academic_program.users.last
      NotificationsMailer.new_notification(director.id, director.notifications.last.id).deliver_now()
      end
    end
    if (self.saces_date - Date.today).numerator == 30  || (self.saces_date - Date.today).numerator == 15 || (self.saces_date - Date.today).numerator == 7
      if self.academic_program.users.any?
      self.academic_program.users.last.notifications.create(
        title: "Fecha SACES aproximandose",
        message: "El proceso #{self.academic_process.name} tiene programado el proceso de SACES en #{(self.saces_date - Date.today).numerator} dias,  se aconseja que se tramite su renovacion prontamente",
        launch: Rails.application.routes.url_helpers.faculty_academic_program_process_academic_program_procedures_path(
          faculty_id: self.academic_program.faculty.id,
          academic_program_id: self.academic_program.id,
          process_academic_program_id: self.id
          )
        )
      director = self.academic_program.users.last
      NotificationsMailer.new_notification(director.id, director.notifications.last.id).deliver_now()
      end
    end
    if (self.academic_council_date - Date.today).numerator == 30  || (self.academic_council_date - Date.today).numerator == 15 || (self.academic_council_date - Date.today).numerator == 7
      if self.academic_program.users.any?
      self.academic_program.users.last.notifications.create(
        title: "Fecha de consejo acaemico aproximandose",
        message: "El proceso #{self.academic_process.name} tiene programado el proceso de consejo academico en #{(self.academic_council_date - Date.today).numerator} dias,  se aconseja que se tramite su renovacion prontamente",
        launch: Rails.application.routes.url_helpers.faculty_academic_program_process_academic_program_procedures_path(
          faculty_id: self.academic_program.faculty.id,
          academic_program_id: self.academic_program.id,
          process_academic_program_id: self.id
          )
        )
      director = self.academic_program.users.last
      NotificationsMailer.new_notification(director.id, director.notifications.last.id).deliver_now()
      end
    end
  end


end
