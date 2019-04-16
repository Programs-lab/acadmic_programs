class WorkingDaysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_working_day

  def update
      if @working_day.update(working_day_params)
        redirect_to working_weeks_path, notice: 'El horario fue actualizado exitosamente'
      else
        redirect_to working_weeks_path, alert: 'El horario no pudo ser actualizado'
      end
  end

  private

  def set_working_day
    @working_day = WorkingDay.find(params[:id])
  end

  def working_day_params
    params.require(:working_day).permit(working_hours_attributes: [:id, :initial_hour, :end_hour, :procedure_type_id, :remember, :_destroy])
  end

end
