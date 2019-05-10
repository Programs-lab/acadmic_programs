class MedicalRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: :medical_record
  before_action :set_appointment, only: :medical_record
  before_action :set_medical_record, only: :create

  def medical_record
    @appointment_reports = @patient.patient_medical_records.any? ? @patient.patient_medical_records.first.appointment_reports : []
  end

  def create
    @appointment_report = @medical_record.appointment_reports.new(appointment_report_params)

    if @appointment_report.save
      redirect_to medical_record_path(@medical_record.patient_id), notice: "El diagnostico del paciente fue creado correctamente"
    else
      redirect_to medical_record_path(@medical_record.patient_id), flash: { danger: "El diagnostico del paciente no pudo ser creado"}
    end
  end

  private

  def set_patient
    @patient = User.find(params[:patient_id])
  end

  def set_appointment
    @appointment = params[:appointment_id] ? Appointment.find(params[:appointment_id]) : nil
  end

  def set_medical_record
    @medical_record = MedicalRecord.find_or_create_by(patient_id: params[:patient_id])
  end

  def appointment_report_params
    params.require(:medical_record).permit(
      :appointment_id,
      :appointment_datetime,
      :diagnosis,
      :medical_order,
      :medical_disability,
      :reference,
      :examination_request
    )
  end
end
