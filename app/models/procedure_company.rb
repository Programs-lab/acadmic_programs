class ProcedureCompany < ApplicationRecord
  belongs_to :company
  belongs_to :procedure_type
end
