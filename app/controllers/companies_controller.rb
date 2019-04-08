class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:update, :destroy]
  def index
    @companies = Company.all.order(:id)
    authorize @companies
  end

  def create
    @company = Company.new(company_params)
    authorize @company
    if @company.save
      redirect_to companies_path, notice: 'La empresa fue agregada exitosamente.'
    else
      redirect_to companies_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end    
  end

  def update
    authorize @company
    if @company.update(company_params)
      redirect_to companies_path, notice: 'La empresa fue actualizado exitosamente.'
    else
      redirect_to companies_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end

  def destroy
    authorize @company
    if @company.destroy
      redirect_to companies_path, notice: 'La empresa fue eliminada correctamente.'
    end
  end

  def update_procedure_companies
    update_procdure_companies(params)
  end

  private

  def set_company
    @company = Company.find(params[:id] || params[:company_id])
  end

  def company_params
    params.require(:company).permit(:company_name, :company_id)
  end

end
