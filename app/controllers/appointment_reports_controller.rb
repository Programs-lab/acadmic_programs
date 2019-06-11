class AppointmentReportsController < ApplicationController
  before_action :authenticate_user!

  def show
    @appointment_report = AppointmentReport.find(params[:id])
    @patient = @appointment_report.medical_record.patient
    respond_to do |format|
      format.html
      format.pdf do 
        render pdf: "Historial clinico de #{@patient.first_name} #{@patient.last_name} (#{Date.today})",
        template: "appointment_reports/show.html.erb",
        layout: "pdf.html",
        zoom: 0.78125,
        dpi: 75,
        page_size: 'Letter',
        encoding: 'utf8'
      end
    end
  end

end
