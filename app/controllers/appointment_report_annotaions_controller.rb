class AppointmentReportAnnotationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_procedure_type, only: [:update, :destroy]
  def index
    @appointment_report_annotations = @appointment_report.all.order(:id)
    authorize @appointment_report_annotations
  end

  def create
    @appointment_report_annotation = @appointment_report.new(procedure_type_params)
    authorize @appointment_report_annotation
    if @appointment_report_annotation.save
      redirect_to procedure_types_path, notice: 'El tipo de estudio fue agregado exitosamente.'
    else
      redirect_to procedure_typea_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end

  def update
    authorize @appointment_report_annotation
    if @appointment_report_annotation.update(procedure_type_params)
      redirect_to procedure_types_path, notice: 'El tipo de estudio fue actualizado exitosamente.'
    else
      redirect_to procedure_types_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end

  def destroy
    authorize @appointment_report_annotations
    if @appointment_report_annotation.destroy
      redirect_to procedure_types_path, notice: 'El tipo de estudio fue eliminado correctamente.'
    end
  end

  private

  def set_appointment_report
    @@appointment_report = AppointmentReport.find(params[:id] 
  end

  def set_appointment_report_annotation
    @@appointment_report_annotation = AppointmentReportAnnotation.find(params[:id] 
  end

  def appointment_report_annotation_params
    params.require(:procedure_type).permit(:procedure_type_name, :cost, :procedure_duration, :kind)
  end

end
