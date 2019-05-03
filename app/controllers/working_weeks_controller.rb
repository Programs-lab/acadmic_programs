class WorkingWeeksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_working_week, only: :update

  def index
    @working_week = current_user.doctor_working_weeks.first
    @working_weeks = current_user.doctor_working_weeks.where("end_date >= ?", Date.today).order(:initial_date).to_json(include: {working_days: { include: {working_hours: {except: [:created_at, :updated_at]}}, except: [:created_at, :updated_at]}})
    #authorize @working_week
  end

  def update
    if @working_week.update(working_week_params)
      redirect_to working_weeks_path, notice: 'El horario fue actualizado exitosamente'
    else
      redirect_to working_weeks_path, alert: 'El horario no pudo ser actualizado, es psoible que haya tratado de registrar horarios en blanco'
    end
  end

  def create
      parameters = working_week_params
      parameters[:initial_date] = Date.parse(parameters[:initial_date])
      parameters[:end_date] = Date.parse(parameters[:end_date])
      next_week = []
      @working_week = WorkingWeek.new(parameters)
      flash[:notice] = "Se ha guardado este horario para el siguiente mes"
      authorize @working_week

    4.times.each do |index|
      @working_week = WorkingWeek.new(parameters)
      unless @working_week.save
        flash.except!(:notice)
        flash[:alert] = "No fue posible concretar el registro, por favor revise los campos nuevamente"
        break
      end
      parameters[:initial_date] =  parameters[:initial_date].next_week
      parameters[:end_date] = parameters[:end_date].next_week.end_of_week - 2
      next_week = (parameters[:initial_date]..parameters[:end_date]).map.to_a
      parameters[:working_days_attributes].each_with_index do |wday, i|
        wday[:working_date] = next_week[i]
        wday[:working_hours_attributes].each_with_index do |wh, n|
          wh[:initial_hour] = DateTime.parse("#{wday[:working_date].to_s} #{DateTime.parse(wh[:initial_hour].to_s).strftime("%H:%M%p")} -0500")
          wh[:end_hour] = DateTime.parse("#{wday[:working_date].to_s} #{DateTime.parse(wh[:end_hour].to_s).strftime("%H:%M%p")} -0500")
        end
      end
    end 
    redirect_to working_weeks_path

  end

  private

  def set_working_week
    @working_week = WorkingWeek.find(params[:id])
  end

  def working_week_params
    params.require(:working_week).permit(:doctor_id, :initial_date, :end_date, working_days_attributes: [:id, :working_date, working_hours_attributes: [:id, :initial_hour, :end_hour, :procedure_type_id, :remember, :_destroy]])
  end

end
