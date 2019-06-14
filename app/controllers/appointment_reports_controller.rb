# coding: utf-8
class AppointmentReportsController < ApplicationController

  before_action :authenticate_user!

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
                           locals: {title: "HISTORIA CLINICA", patient: @patient}
                         },
                     },
            footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
            zoom: 0.8,
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
                          locals: {title: "ORDENES MEDICAS", patient: @patient}
                        },
                    },
            footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
            zoom: 0.8,
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
                            locals: {title: "SOLICITUD DE EXAMENES", patient: @patient}
                          },
                      },
              footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
              zoom: 0.8,
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
                                                locals: {title: "INCAPACIDAD MEDICA", patient: @patient}
                                              },
                                          },
                                 footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
                                 zoom: 0.8,
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
                                                locals: {title: "REFERENCIA", patient: @patient}
                                              },
                                          },
                                 footer:  {   html: { template: "medical_records/medical_record_footer.html.erb" }},
                                 zoom: 0.8,
                                 dpi: 75,
                                 encoding: 'utf8',
                                 locals: {patient: @patient, appointment_report: @appointment_report, field: @appointment_report.reference }




        pdf = CombinePDF.new
        pdf << CombinePDF.parse(pdf1)
        pdf << CombinePDF.parse(pdf2)
        pdf << CombinePDF.parse(pdf3)
        pdf << CombinePDF.parse(pdf4)
        pdf << CombinePDF.parse(pdf5)
        send_data pdf.to_pdf, filename: "Reporte cita de #{@patient.first_name} #{@patient.last_name} (#{@appointment_report.appointment_datetime.strftime('%d/%m/%Y')})", type: "application/pdf"

      end
    end
  end
end
