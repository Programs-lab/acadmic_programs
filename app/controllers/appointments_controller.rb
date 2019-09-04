class AppointmentsController < ApplicationController
  before_action :authenticate_user!, except: [:schedule_appointment_no_user, :create_appointment, :update_appointment]
  before_action :patient, only: [:create, :create_schedule_appointment]
  before_action :get_variables_appointment, only: [:new, :schedule_appointment_no_user, :schedule_appointment]

  def index
    patient = User.find(current_user.id)
    @appointments = patient.patient_appointments.where(state: :pending).where('appointment_datetime >= ?', DateTime.now)
    medical_record = patient.patient_medical_records.first
    @appointment_history = patient.patient_appointments.where('appointment_datetime <= ? OR state = ? OR state = ?', DateTime.now, 2, 3)
    @pagy, @appointment_history = pagy(@appointment_history, items: 5)
  end

  def new
    @procedure_types = ProcedureType.all
  end

  def schedule_appointment_no_user
    @procedure_types = ProcedureType.all
  end

  def schedule_appointment
    @procedure_types = ProcedureType.all
  end

  def attend_appointment
    @appointment = Appointment.find(params[:appointment_id])
    if @appointment.pending?
      @appointment.assign_attributes({state: :attended})
      @appointment.save(validate: false)
      redirect_to request.referer
    else
      @appointment.assign_attributes({state: :pending})
      @appointment.save(validate: false)
      redirect_to request.referer
    end
    authorize @appointment
  end

  def scheduled_appointments
    @date = params[:date].present? ? DateTime.parse(params[:date]) : DateTime.now
    unless params[:patient_id].present?
      @appointments = current_user.doctor_appointments.where(appointment_datetime: @date.beginning_of_day..@date.end_of_day).order(:appointment_datetime)
    else
      if params[:date].blank?      
        @appointments = current_user.doctor_appointments.where(state: :pending, patient_id: params[:patient_id]).where('appointment_datetime >= ?', DateTime.now).order(:appointment_datetime)
      else
        @appointments = current_user.doctor_appointments.where(appointment_datetime: @date.beginning_of_day..@date.end_of_day).search_by_details(params[:patient_id]).order(:appointment_datetime)  
      end
    end
    @pagy, @appointments = pagy(@appointments, items: 10)
  end

  def all_appointments
    @search_params = query_params
    @date = params[:date].present? ? DateTime.parse(params[:date]) : DateTime.now
    unless @search_params.present?
      @appointments = Appointment.where(appointment_datetime: @date.beginning_of_day..@date.end_of_day).order(:appointment_datetime)
    else
      if @search_params[:appointment_datetime].present?
        @search_params[:appointment_datetime] = Date.parse(@search_params[:appointment_datetime]).beginning_of_day..Date.parse(@search_params[:appointment_datetime]).end_of_day
        @appointments = Appointment.where(@search_params).order(:appointment_datetime)
      else
        @appointments = Appointment.where(state: :pending).where('appointment_datetime >= ?', DateTime.now).where(@search_params).order(:appointment_datetime)
      end                  
    end
    @pagy, @appointments = pagy(@appointments, items: 5)
  end

  def create    
  appointments = @patient.patient_appointments.where('appointment_datetime > ? AND state = ?', DateTime.now, 1).any?
    unless appointments
      @appointment = @patient.patient_appointments.new(appointments_params)
      if @appointment.save
        redirect_to appointments_path, notice: 'La cita fue agendada correctamente'
      else
        redirect_to appointments_path, flash: {danger: 'Ocurrio un error al crear la cita, por favor intente de nuevo.'}
      end
    else
      redirect_to appointments_path, flash: {danger: 'No se pudo crear la cita debido a que tiene citas activas'}
    end
  end

  def create_schedule_appointment
    appointments = @patient.patient_appointments.where('appointment_datetime > ? AND state = ?', DateTime.now, 1).includes(:procedure_type)
    checkup_apointment_count = appointments.includes(:procedure_type).where(procedure_types: {kind: :consulta}).references(:procedure_type).count
    procedure_type = ProcedureType.find(appointments_params[:procedure_type_id])
    condition = procedure_type.consulta? ? checkup_apointment_count < 1 : true

    if condition
      @appointment = @patient.patient_appointments.new(appointments_params)
      if @appointment.save
        redirect_to admin_patients_path, notice: 'La cita fue agendada correctamente'
      else        
        redirect_to schedule_appointment_path(@patient), flash: {danger: 'Ocurrio un error al crear la cita, por favor intente de nuevo.'}
      end
    else
      redirect_to schedule_appointment_path(@patient), flash: {danger: 'No se pudo crear la cita debido a que tiene citas activas'}
    end
  end
  
 def schedule_appointment_no_user
    @doctors = User.where(role: :doctor).includes(:doctor_working_weeks).where("working_weeks.end_date > ?", Date.today).references(:doctor_working_weeks)
    @doctor_id = @doctors.any? ? @doctors.first.id : []
    @procedure_types = ProcedureType.all
 end  

  def create_appointment
    patient = User.new(user_params)
    if patient.save
      appointment = Appointment.create(appointments_params.merge({patient_id: patient.id, procedure_type_id: ProcedureType.all.first.id, state: :disabled}))
      patient.send_confirmation_instructions
      AppointmentWorker.perform_in(30.minutes, patient.id)
      redirect_to user_session_path, notice: 'Su cita esta reservada pero aun no esta activa por favor siga las instrucciones enviadas al correo electronico especificado para concretarla'
    else
      redirect_to schedule_appointment_no_user_path, alert: 'No pudo ser registrado'
    end
  end

  def update_appointment
    patient = User.where(id_number: params[:appointment][:id_number]).first
    appointments = patient.patient_appointments.where('appointment_datetime > ? AND (state = ? OR state = ?)', DateTime.now, 1, 0).any?

    unless appointments
      @appointment = Appointment.new(appointments_params.merge({patient_id: patient.id, state: :disabled}))
      if @appointment.save
        AppointmentWorker.perform_in(30.minutes, patient.id)
        redirect_to user_session_path, notice: 'Su cita ha sido creada debe iniciar sesion en los proximos 30 minutos para que se confirme'
      else
        redirect_to schedule_appointment_no_user_path, flash: {danger: 'Su cita no pudo ser creada, por favor intente de nuevo'}
      end
    else
      redirect_to schedule_appointment_no_user_path, flash: {danger: 'No se pudo crear la cita debido a que tiene citas activas'}
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    if @appointment.destroy
      redirect_to appointments_path, notice: 'La cita fue eliminada correctamente.'
    end
  end

  def cancel_appointment
    user = User.find(params[:current_user_id])    
    reason = params[:reason].blank? ? nil : params[:reason]
    appointment = Appointment.find(params[:appointment_id])
    mail_to = user.doctor? ? appointment.patient.id : appointment.doctor.id    
    mail = AppointmentsMailer.canceled_appointment(mail_to, appointment.id, reason)
    appointment.update(state: :canceled)
    mail.deliver_now
    redirect_to request.referer
  end

  private

  def patient
    @patient = params[:patient_id] ? User.find(params[:patient_id]) : current_user
  end

  def get_variables_appointment
    @doctors = User.where(role: :doctor).includes(:doctor_working_weeks).where("working_weeks.end_date > ?", Date.today).references(:doctor_working_weeks)
    @doctor_id = @doctors.any? ? @doctors.first.id : []
  end

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
