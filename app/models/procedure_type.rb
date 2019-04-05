class ProcedureType < ApplicationRecord
  has_many :procedure_companies
  has_many :appointments
end
