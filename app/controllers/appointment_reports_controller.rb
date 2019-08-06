# coding: utf-8
class AppointmentReportsController < ApplicationController

  before_action :authenticate_user!, only: [:show]
  before_action :set_appointment_report, only: [:index, :update]

  def show
    @appointment_report = AppointmentReport.find(params[:id])
    @patient = @appointment_report.medical_record.patient
    respond_to do |format|
      format.html
      format.pdf do
        pdf1 = render_to_string  pdf: "Historial clinico de #{@patient.first_name} #{@patient.last_name} (#{Date.today})",
            template: "appointment_reports/show.html.erb",
            layout: 'pdf.html.erb',
            page_size: 'Letter',
            margin: { top:  40,
                      bottom: 25,
                      left: 20,
                      right: 30                },
            header:  {   html: {
                           template: "medical_records/medical_record_header.html.erb",
                           locals: {title: "HISTORIA CLINICA", patient: @patient, format_code: "MPM-CE-F-01"}
                         },
                     },
            footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
            zoom: 1,
            dpi: 75,
            encoding: 'utf8',
            locals: {patient: @patient, appointment_report: @appointment_report}

        pdf2 = render_to_string  pdf: "Historial clinico de #{@patient.first_name} #{@patient.last_name} (#{Date.today})",
            template: "appointment_reports/medical_order.html.erb",
            layout: 'pdf.html.erb',
            page_size: 'Letter',
            margin: { top:  40,
                      bottom: 25,
                      left: 20,
                      right: 30                },
            header:  {   html: {
                          template: "medical_records/medical_record_header.html.erb",
                          locals: {title: "ORDENES MEDICAS", patient: @patient, format_code: "MPM-CE-F-02"}
                        },
                    },
            footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
            zoom: 1,
            dpi: 75,
            encoding: 'utf8',
            locals: {patient: @patient, appointment_report: @appointment_report, field: @appointment_report.medical_order}
        pdf3 = render_to_string  pdf: "Historial clinico de #{@patient.first_name} #{@patient.last_name} (#{Date.today})",
              template: "appointment_reports/medical_order.html.erb",
              layout: 'pdf.html.erb',
              page_size: 'Letter',
              margin: { top:  40,
                        bottom: 25,
                        left: 20,
                        right: 30                },
              header:  {   html: {
                            template: "medical_records/medical_record_header.html.erb",
                            locals: {title: "SOLICITUD DE EXAMENES", patient: @patient, format_code: "MPM-CE-F-03"}
                          },
                      },
              footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
              zoom: 1,
              dpi: 75,
              encoding: 'utf8',
              locals: {patient: @patient, appointment_report: @appointment_report, field: @appointment_report.examination_request }

        pdf4 = render_to_string  pdf: "Historial clinico de #{@patient.first_name} #{@patient.last_name} (#{Date.today})",
                                 template: "appointment_reports/medical_order.html.erb",
                                 layout: 'pdf.html.erb',
                                 page_size: 'Letter',
                                 margin: { top:  40,
                                           bottom: 25,
                                           left: 20,
                                           right: 30                },
                                 header:  {   html: {
                                                template: "medical_records/medical_record_header.html.erb",
                                                locals: {title: "INCAPACIDAD MEDICA", patient: @patient, format_code: "MPM-CE-F-05"}
                                              },
                                          },
                                 footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
                                 zoom: 1,
                                 dpi: 75,
                                 encoding: 'utf8',
                                 locals: {patient: @patient, appointment_report: @appointment_report, field: @appointment_report.medical_disability }

        pdf5 = render_to_string  pdf: "Historial clinico de #{@patient.first_name} #{@patient.last_name} (#{Date.today})",
                                 template: "appointment_reports/medical_order.html.erb",
                                 layout: 'pdf.html.erb',
                                 page_size: 'Letter',
                                 margin: { top:  40,
                                           bottom: 25,
                                           left: 20,
                                           right: 30                },
                                 header:  {   html: {
                                                template: "medical_records/medical_record_header.html.erb",
                                                locals: {title: "REFERENCIA", patient: @patient, format_code: "MPM-CE-F-04"}
                                              },
                                          },
                                 footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
                                 zoom: 1,
                                 dpi: 75,
                                 encoding: 'utf8',
                                 locals: {patient: @patient, appointment_report: @appointment_report, field: @appointment_report.reference }




        pdf = CombinePDF.new
        pdf << CombinePDF.parse(pdf1)
        pdf << CombinePDF.parse(pdf2)
        pdf << CombinePDF.parse(pdf3)
        pdf << CombinePDF.parse(pdf4)
        pdf << CombinePDF.parse(pdf5)
        send_data pdf.to_pdf, disposition: 'inline', filename: "Reporte cita de #{@patient.first_name} #{@patient.last_name} (#{@appointment_report.appointment_datetime.strftime('%d/%m/%Y')})", type: "application/pdf"

      end
    end
  end

  def index
    @medical_record = MedicalRecord.find(params[:medical_record_id])

    @appointment_report_annotations = @appointment_report.appointment_report_annotations.order(:created_at)
    render json: {appointment_report_annotations: @appointment_report_annotations.to_json(except: [:updated_at]) }
  end

  def update
    unless @appointment_report.update(appointment_report_params)
      redirect_to working_weeks_path, alert: "Hubo un error al tratar de actualizar por favor intente de nuevo"
    end
  end

  private

  def set_appointment_report
    @appointment_report = AppointmentReport.find(params[:id])
  end

  def appointment_report_params
    params.require(:appointment_report).permit(appointment_report_annotations_attributes: [:id, :content, :_destroy])
  end

end
