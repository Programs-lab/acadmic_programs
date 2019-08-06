class WorkingWeeksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_working_week, only: [:update, :update_all]
  protect_from_forgery with: :null_session

  def index
    @doctor = current_user
    if params[:doctor_id]
      if current_user.admin?
        @doctor = User.find(params[:doctor_id])
      else
        flash[:danger] = 'No se encuentra autorizado para completar esta acción'
        redirect_to root_path || request.referrer
      end
    end
    unproccessed_working_weeks = @doctor.doctor_working_weeks.where("end_date >= ?", Date.today).order(:initial_date)
    @working_weeks = unproccessed_working_weeks.to_json(include: {working_days: { include: {working_hours: {except: [:created_at, :updated_at]}}, except: [:created_at, :updated_at]}})
    authorize unproccessed_working_weeks
  end

  def update
    authorize @working_week
    if @working_week.update(working_week_params)
      redirect_to working_weeks_path, notice: 'El horario fue actualizado exitosamente'
    else
      redirect_to working_weeks_path, alert: "El horario no pudo ser actualizado, #{@working_week.errors.messages[:"working_days.working_hours.working_hours"][0]}"
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

    5.times.each do |index|
      @working_week = WorkingWeek.new(parameters)
      unless @working_week.save
        flash.except!(:notice)
        flash[:alert] = "No fue posible concretar el registro, por favor revise los campos nuevamente"
        break
      end
      set_up_next_week(parameters, next_week)
    end 
    redirect_to working_weeks_path

  end

  private

  def set_working_week
    @working_week = WorkingWeek.find(params[:id])
  end

  def set_up_next_week(parameters, next_week)  
    parameters[:initial_date] =  parameters[:initial_date].next_week
    parameters[:end_date] = parameters[:end_date].next_week.end_of_week - 2
    next_week = (parameters[:initial_date]..parameters[:end_date]).map.to_a
    parameters[:working_days_attributes].each_with_index do |wday, i|
      wday[:id] = nil
      wday[:working_date] = next_week[i]
      wday[:working_hours_attributes].each_with_index do |wh, n|
        wh[:id] = nil
        wh[:initial_hour] = DateTime.parse("#{wday[:working_date].to_s} #{DateTime.parse(wh[:initial_hour].to_s).strftime("%H:%M%p")} -0500")
        wh[:end_hour] = DateTime.parse("#{wday[:working_date].to_s} #{DateTime.parse(wh[:end_hour].to_s).strftime("%H:%M%p")} -0500")
      end
    end
  end


  def working_week_params
    params.require(:working_week).permit(:doctor_id, :initial_date, :end_date, working_days_attributes: [:id, :working_date, working_hours_attributes: [:id, :initial_hour, :end_hour, :remember, :_destroy, procedure_type_kinds: []]])
  end

end
