class ProcedureCompany < ApplicationRecord
  belongs_to :company, dependent: :destroy
  belongs_to :procedure_type
end
