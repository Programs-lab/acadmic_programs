class AppointmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @appointments = User.find(current_user.id).patient_appointments
  end

  def new
    @doctor_id = User.where(role: :doctor).first.id
    @doctors = User.where(role: :doctor).includes(:doctor_working_weeks).where("working_weeks.end_date > ?", Date.today).references(:doctor_working_weeks)
    @procedure_types = ProcedureType.where("lower(procedure_type_name) LIKE ?", "consulta%")
  end

  def create
    appointments = current_user.patient_appointments.where('appointment_datetime > ?', DateTime.now).any?
    @appointment = Appointment.new(appointments_params.merge({patient_id: current_user.id}))
    unless appointments
      if @appointment.save
        redirect_to appointments_path, notice: 'La cita fue agendada correctamente'
      end
    else
      redirect_to appointments_path, flash: {danger: 'No se pudo crear la cita debido a que tiene citas activas'}
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    if @appointment.destroy
      redirect_to appointments_path, notice: 'La cita fue eliminada correctamente.'
    end
  end

  private

  def appointments_params
    params.require(:appointment).permit(
      :appointment_datetime,
      :doctor_id,
      :procedure_type_id
    )
  end
end
