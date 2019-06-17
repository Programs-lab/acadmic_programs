class MedicalRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:medical_record, :show]
  before_action :set_appointment, only: :medical_record
  before_action :set_medical_record, only: [:create, :medical_record]

  def show
    medical_record = @patient.patient_medical_records
    @appointment_reports = AppointmentReport.where(medical_record_id: medical_record.pluck(:id)).order(appointment_datetime: :desc)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Historial clinico de #{@patient.first_name} #{@patient.last_name} (#{Date.today})",
        template: "medical_records/medical_record_complete.html.erb",
        layout: "pdf.html",
        margin: { top:  40,
                  bottom: 25,
                  left: 20,
                  right: 30                },
        header:  {   html: {
                       template: "medical_records/medical_record_header.html.erb",
                       locals: {title: "HISTORIA CLINICA", patient: @patient}
                     },
                 },
        footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
        zoom: 4,
        dpi: 75,
        page_size: 'Letter',
        encoding: 'utf8'
      end
    end
  end

  def index
    patient = current_user
    medical_record = patient.patient_medical_records
    @appointment_reports = AppointmentReport.where(medical_record_id: medical_record.pluck(:id))

    authorize @appointment_reports
  end

  def medical_record
    @appointment_reports = @patient.patient_medical_records.any? ? @patient.patient_medical_records.first.appointment_reports : []
  end

  def create    
    @appointment_report = @medical_record.appointment_reports.new(appointment_report_params)
    if @appointment_report.save     
      redirect_to patient_medical_record_path(@medical_record.patient_id), notice: "El diagnostico del paciente fue creado correctamente"
    else
      redirect_to patient_medical_record_path(@medical_record.patient_id), flash: { danger: "El diagnostico del paciente no pudo ser creado"}
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
    params.require(:appointment_report).permit(
      :doctor_id,
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
