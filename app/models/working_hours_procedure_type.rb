class WorkingHoursProcedureType < ApplicationRecord
  belongs_to :procedure_type
  belongs_to :working_hour
end
