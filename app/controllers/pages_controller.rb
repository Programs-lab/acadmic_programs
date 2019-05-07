class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:schedule_appointment_no_user, :create, :update]

  def home
  end

  def medical_record
  end

  def schedule_appointment_no_user
    @doctor_id = User.where(role: :doctor).first.id
    @doctors = User.where(role: :doctor).includes(:doctor_working_weeks).where("working_weeks.end_date > ?", Date.today).references(:doctor_working_weeks)
    @procedure_types = ProcedureType.where("lower(procedure_type_name) LIKE ?", "consulta%")
  end

  def create
    patient = User.new(user_params)
    if patient.save
      appointment = Appointment.create(appointment_params.merge({patient_id: patient.id, procedure_type_id: ProcedureType.all.first.id }))
      patient.send_confirmation_instructions
      redirect_to user_session_path, notice: 'Debe confirmar su cuenta antes de continuar'
    else
      redirect_to schedule_appointment_no_user_path, alert: 'No pudo ser registrado'
    end
  end

  def update
    patient = User.where(id_number: params[:user_appointment][:id_number]).first
    Appointment.create(appointment_params.merge({patient_id: patient.id, procedure_type_id: ProcedureType.all.first.id }))
    redirect_to user_session_path, notice: 'Su cita ha sido creada, por favor inicie sesion para que se confirme'
  end

  private

  def user_params
    params.require(:user_appointment).permit(
      :first_name,
      :last_name,
      :id_type,
      :id_number,
      :occupation,
      :address,
      :birthdate,
      :phone_number,
      :email,
      :password,
      :password_confirmation
    )
  end

  def appointment_params
    params.require(:user_appointment).permit(
      :appointment_datetime,
      :doctor_id
    )
  end
end
