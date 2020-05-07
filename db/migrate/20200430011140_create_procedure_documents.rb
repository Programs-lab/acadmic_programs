class CreateProcedureDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :procedure_documents do |t|
    	t.references :procedure
    	t.references :document
    	t.references :user
    end
  end
end
