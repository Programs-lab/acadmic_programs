class Company < ApplicationRecord
  has_many :users
  has_many :procedure_companies, dependent: :destroy
  after_create :create_procedure_companies

  def self.update_procdure_companies(params)
    ProcedureCompany.update(params.keys, params.values)
  end

  def create_procedure_companies
    if ProcedureType.any?
      ProcedureType.all.each do |pt|
        ProcedureCompany.create(company_id: self.id, procedure_type_id: pt.id, cost: pt.cost)
      end
    end
    
  end
end
