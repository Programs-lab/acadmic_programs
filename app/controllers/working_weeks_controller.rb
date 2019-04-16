class WorkingWeeksController < ApplicationController
  before_action :authenticate_user!

  def index
    @working_week = current_user.doctor_working_weeks.last
    #authorize @working_week
  end

  def create
    @working_week = WorkingWeek.new(working_week_params)
    authorize @working_week
    if @working_week.save
      redirect_to procedure_types_path, notice: 'El tipo de estudio fue agregado exitosamente.'
    else
      redirect_to procedure_typea_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end

  private

  def working_week_params
    params.require(:working_week).permit(working_days_attributes: [:id, working_hours_attributes: [:id, :initial_hour, :end_hour, :procedure_type_id]])
  end

end
