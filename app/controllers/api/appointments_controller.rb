class Api::AppointmentsController < ApplicationController
  def fetch_appointment_data
    @doctor = User.where(id: params[:doctor_id]).includes(:doctor_working_weeks).where("working_weeks.end_date > ?", Date.today).references(:doctor_working_weeks).to_json(
      only: [:first_name, :last_name, :id],
      include:
      { doctor_working_weeks:
        { only: [:initial_date, :end_date],
          include:
          { working_days:
            { only: [:working_date],
              include:
              {
                working_hours: {only: [:initial_hour, :end_hour]}
              }
              }
            }
        }
      }
    )
    appointment_registered = AppointmentReport.pluck(:appointment_id)
    @unavailable_working_hours = Appointment.where.not(id: appointment_registered).where(doctor_id: params[:doctor_id])
    @unavailable_working_hours = @unavailable_working_hours.where('appointment_datetime >= ?', DateTime.now).to_json(only: [:doctor_id, :appointment_datetime])

    render json: { doctor: @doctor, unavailable_working_hours: @unavailable_working_hours }
  end
end
