class ProcessesAcademicProgram < ApplicationRecord
  belongs_to :academic_process
  belongs_to :academic_program
  has_many :men_backups, dependent: :destroy
  before_update :calculate_dates
  before_update :save_backup
  has_many :media, dependent: :destroy

  def calculate_dates
    self.expiration_date = self.men_date + self.validity.years
    self.saces_date = self.men_date + self.academic_process.year_saces.years + self.academic_process.month_saces.months + self.academic_process.day_saces.days
    self.academic_council_date = self.men_date + self.academic_process.year_academic_council.years + self.academic_process.month_academic_council.months + self.academic_process.day_academic_council.days
  end

  def save_backup
    if men_date_changed? && resolution_changed?
      self.men_backups.create(resolution: self.resolution, men_date: self.men_date)
    end
  end
end
