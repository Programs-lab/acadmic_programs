class WorkingDay < ApplicationRecord
  belongs_to :working_week
  has_many :working_hours, dependent: :delete_all
  accepts_nested_attributes_for :working_hours, reject_if: :all_blank, allow_destroy: true
  #after_create :create_wroking_hours

  def create_wroking_hours
    doctor = self.working_week.doctor
    remembered_working_hours = WorkingHour.includes(working_day: :working_week).where(working_days: {working_weeks: {doctor_id: doctor.id}}, remember: true)
    remembered_working_hours.each do |wh|
      if wh.working_day.working_date.wday == self.working_date.wday
        attrs = wh.attributes.except!("id", "created_at", "updated_at", "working_day_id")
        attrs.merge!("working_day_id" => self.id)
        WorkingHour.create(attrs)
        wh.update(remember: false) 
      end  
    end

  end


end
