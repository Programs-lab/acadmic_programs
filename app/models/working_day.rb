class WorkingWeek < ApplicationRecord
  belongs_to :working_week
  has_many :working_hours
end
