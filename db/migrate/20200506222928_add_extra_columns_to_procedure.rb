class AddExtraColumnsToProcedure < ActiveRecord::Migration[5.2]
  def change
  	add_column :procedures, :closed_date, :date
  	add_column :procedure_documents, :procedure_document_file, :string
  end
end
