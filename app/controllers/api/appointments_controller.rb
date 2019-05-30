class Api::AppointmentsController < ApplicationController
  def fetch_appointment_data
    @doctor = User.where(id: params[:doctor_id]).includes(doctor_working_weeks: { working_days: :working_hours}).where("working_weeks.end_date >= ? AND working_hours.procedure_type_id = ?", (Date.today + 1), params[:procedure_type_id]).references(:doctor_working_weeks).to_json(
      only: [:first_name, :last_name, :id],
      include:
      { doctor_working_weeks:
        { only: [:initial_date, :end_date],
          include:
          { working_days:
            { only: [:working_date],
              include:
              {
                working_hours: {only: [:id, :initial_hour, :end_hour]}
              }
              }
            }
        }
      }
    )

<<<<<<< Updated upstream
    appointment_registered = AppointmentReport.pluck(:appointment_id)
    @unavailable_working_hours = Appointment.where.not(id: appointment_registered).where(doctor_id: params[:doctor_id])
=======
    @unavailable_working_hours = Appointment.where.not(state: :completed).where.not(state: :canceled).where(doctor_id: params[:doctor_id])
>>>>>>> Stashed changes
    @unavailable_working_hours = @unavailable_working_hours.where('appointment_datetime >= ?', DateTime.now).to_json(only: [:doctor_id, :appointment_datetime])

    render json: { doctor: @doctor, unavailable_working_hours: @unavailable_working_hours }
  end

  def fetch_user
    @user = User.where(id_type: params[:id_type], id_number: params[:id_number], role: :patient).to_json(only: [:first_name, :last_name, :phone_number, :company_id, :occupation, :address, :email])

    render json: @user
  end

  def unavialbale_working_hours

    appointments = Appointment.where.not(state: :completed).where.not(state: :canceled).where(doctor_id: params[:doctor_id])
    appointments = appointments.where('appointment_datetime >= ?', DateTime.now).pluck(:appointment_datetime)
    taken_working_hours = []
    appointments.each do |app|
      taken_working_hours = taken_working_hours + WorkingHour.where("initial_hour <= :date AND end_hour > :date", date: app).pluck(:id)
    end


    render json: taken_working_hours
  end


end
