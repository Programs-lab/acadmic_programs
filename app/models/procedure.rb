class Procedure < ApplicationRecord
  belongs_to :processes_academic_program
  has_many :procedure_documents
  after_create :create_procedure_documents


  def create_procedure_documents
  	self.processes_academic_program.academic_process.documents.each do |doc|
  		self.procedure_documents.create(procedure_id: self.id, document_id: doc.id, user_id: self.processes_academic_program.academic_program.users.last.id)
  	end
  end
end
