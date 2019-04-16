class WorkingHour < ApplicationRecord
  belongs_to :working_day
  belongs_to :procedure_type
end
