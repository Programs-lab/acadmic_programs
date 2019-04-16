class WorkingDay < ApplicationRecord
  belongs_to :working_week
  has_many :working_hours, dependent: :destroy
  accepts_nested_attributes_for :working_hours, reject_if: :all_blank, allow_destroy: true
end
