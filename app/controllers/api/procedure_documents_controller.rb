class Api::ProcedureDocumentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def fetch
    @procedure = Procedure.find(params[:id])
    render json: @procedure.procedure_documents.to_json
  end

  def update
    @pd = ProcedureDocument.find(params[:id])
    @pd.update(procedure_document_file: params[:file])
  end

  def remove_file
    @pd = ProcedureDocument.find(params[:id])
    @pd.remove_procedure_document_file = true
    @pd.save!
  end

  def destroy
    @medium = Medium.find(params[:id])
    @medium.destroy
  end

end

