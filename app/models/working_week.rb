class WorkingWeek < ApplicationRecord
  has_many :working_days, -> { order('working_date') }, dependent: :destroy
  belongs_to :doctor, class_name: "User", foreign_key: "doctor_id"
  #after_create :create_working_days
  accepts_nested_attributes_for :working_days, reject_if: :all_blank
  scope :between_date, ->(date) { where('initial_date <= :date AND end_date >= :date', date: date) }

  def create_working_days
    week = (self.initial_date..self.end_date).map.to_a
    week_hash = week.map {|dw| {working_date: dw}}
    self.working_days.create(week_hash)
  end


end
