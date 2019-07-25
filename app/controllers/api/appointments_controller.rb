class Api::AppointmentsController < ApplicationController
  def fetch_appointment_data
    @doctors = User.where(role: :doctor).includes(doctor_working_weeks: { working_days: {working_hours: [:procedure_types, :working_hours_procedure_types] } }).where("working_weeks.end_date >= ? AND procedure_types.id = ?", (Date.today), params[:procedure_type_id]).references(:doctor_working_weeks)
    @doctor = @doctors.where(id: params[:doctor_id])

    @doctors_json = @doctors.to_json(only: [:first_name, :last_name, :id])
    @doctor_json = @doctor.to_json(
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



    @procedure_type = ProcedureType.find(params[:procedure_type_id])
    @unavailable_working_hours = Appointment.where.not(state: :completed).where.not(state: :canceled).where(doctor_id: params[:doctor_id])
    @unavailable_working_hours = @unavailable_working_hours.where('appointment_datetime >= ?', DateTime.now).to_json(only: [:doctor_id, :appointment_datetime])

    render json: { doctors: @doctors_json, doctor: @doctor_json, unavailable_working_hours: @unavailable_working_hours, procedure_type: @procedure_type}
  end


  def fetch_user
    @user = User.where(id_type: params[:id_type], id_number: params[:id_number], role: :patient).to_json(only: [:first_name, :last_name, :phone_number, :company_id, :occupation, :address, :email, :birthdate])

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
