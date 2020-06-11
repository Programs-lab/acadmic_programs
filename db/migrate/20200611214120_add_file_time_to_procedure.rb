class AddFileTimeToProcedure < ActiveRecord::Migration[5.2]
  def change
  	add_column :procedure_documents, :last_uploaded_file_date, :date
  end
end
