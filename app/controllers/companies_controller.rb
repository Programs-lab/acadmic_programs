class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:update, :destroy]
  def index
    @companies = Company.all
    authorize @companies
  end

  def create
    @company = Company.new(user_params)
    authorize @company
    if @company.save
      redirect_to companies_path, notice: 'El usuario fue creado exitosamente.'
    else
      redirect_to companies_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end    
  end

  def update
    authorize @company
    if @company.update(user_params)
      redirect_to companies_path, notice: 'El usuario fue actualizado exitosamente.'
    else
      redirect_to companies_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end

  def destroy
    authorize @company
    if @company.destroy
      redirect_to companies_path, notice: 'El usuario fue eliminado correctamente.'
    end
  end

  private

  def set_company
    @company = Company.find(params[:id] || params[:user_id])
  end

  def company_params
    params.require(:company).permit(:company_name)
  end

end
