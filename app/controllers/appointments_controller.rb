class AppointmentsController < ApplicationController
  before_action :authenticate_user!, except: [:schedule_appointment_no_user, :create_appointment,          :update_appointment]

  def index
    patient = User.find(current_user.id)
    @appointments = patient.patient_appointments.where(attended: false)
    medical_record = patient.patient_medical_records.first
    @appointment_history = medical_record ? medical_record.appointment_reports.where.not(appointment_id: @appointments.pluck(:id)) : []
  end

  def new
    @doctor_id = User.where(role: :doctor).first.id
    @doctors = User.where(role: :doctor).includes(:doctor_working_weeks).where("working_weeks.end_date > ?", Date.today).references(:doctor_working_weeks)
    @procedure_types = ProcedureType.where("lower(procedure_type_name) LIKE ?", "consulta%")
  end

  def create
    appointments = current_user.patient_appointments.where('appointment_datetime > ? AND attended = ?', DateTime.now, false).any?
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

  def schedule_appointment_no_user
    @doctor_id = User.where(role: :doctor).first.id
    @doctors = User.where(role: :doctor).includes(:doctor_working_weeks).where("working_weeks.end_date > ?", Date.today).references(:doctor_working_weeks)
    @procedure_types = ProcedureType.where("lower(procedure_type_name) LIKE ?", "consulta%")
  end

  def create_appointment
    patient = User.new(user_params)
    if patient.save
      appointment = Appointment.create(appointments_params.merge({patient_id: patient.id, procedure_type_id: ProcedureType.all.first.id }))
      patient.send_confirmation_instructions
      redirect_to user_session_path, notice: 'Debe confirmar su cuenta antes de continuar'
    else
      redirect_to schedule_appointment_no_user_path, alert: 'No pudo ser registrado'
    end
  end

  def update_appointment
    patient = User.where(id_number: params[:appointment][:id_number]).first
    appointments = patient.patient_appointments.where('appointment_datetime > ? AND attended = ?', DateTime.now, false).any?

    unless appointments
      @appointment = Appointment.new(appointments_params.merge({patient_id: patient.id}))
      if @appointment.save
        redirect_to user_session_path, notice: 'Su cita ha sido creada, por favor inicie sesion para que se confirme'
      else
        redirect_to schedule_appointment_no_user_path, flash: {danger: 'Su cita no pudo ser creada, por favor intente de nuevo'}
      end
    else
      redirect_to schedule_appointment_no_user_path, flash: {danger: 'No se pudo crear la cita debido a que tiene citas activas'}
    end
  end

  def scheduled_appointments
    @appointments = current_user.doctor_appointments.where('appointment_datetime >= ? AND attended = ? AND disabled = ?', DateTime.now, false, false)
  end

  private

  def user_params
    params.require(:appointment).permit(
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

  def appointments_params
    params.require(:appointment).permit(
      :appointment_datetime,
      :doctor_id,
      :procedure_type_id
    )
  end
end
