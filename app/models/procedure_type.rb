class ProcedureType < ApplicationRecord
  has_many :procedure_companies, dependent: :destroy
  has_many :appointments
  has_many :working_hours
  has_many :doctor_procedure_types
  after_create :create_procedure_company
  enum kind: [:consulta, :procedimiento]

  def create_procedure_company

    if Company.any?
      Company.all.each do |company|
        ProcedureCompany.create(company_id: company.id, procedure_type_id: self.id, cost: self.cost)
      end
    end
  end


end
