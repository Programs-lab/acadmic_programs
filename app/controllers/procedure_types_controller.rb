class ProcedureTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_procedure_type, only: [:update, :destroy]
  def index
    @procedure_types = ProcedureType.all.order(:id)
    @consultations = @procedure_types.where(kind: :consulta)
    @procedures = @procedure_types.where(kind: :procedimiento)
    authorize @procedure_types
  end

  def create
    @procedure_type = ProcedureType.new(procedure_type_params)
    authorize @procedure_type
    if @procedure_type.save
      redirect_to procedure_types_path, notice: 'El tipo de estudio fue agregado exitosamente.'
    else
      redirect_to procedure_typea_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end    
  end

  def update
    authorize @procedure_type
    if @procedure_type.update(procedure_type_params)
      redirect_to procedure_types_path, notice: 'El tipo de estudio fue actualizado exitosamente.'
    else
      redirect_to procedure_types_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end

  def destroy
    authorize @procedure_type
    if @procedure_type.destroy
      redirect_to procedure_types_path, notice: 'El tipo de estudio fue eliminado correctamente.'
    end
  end

  private

  def set_procedure_type
    @procedure_type = ProcedureType.find(params[:id] || params[:procedure_type_id])
  end

  def procedure_type_params
    params.require(:procedure_type).permit(:procedure_type_name, :cost, :procedure_duration, :kind)
  end

end
