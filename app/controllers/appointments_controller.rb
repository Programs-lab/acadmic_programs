class AppointmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @appointments = User.find(current_user.id).patient_appointments
  end

  def new
    @doctors = User.where(role: :doctor).to_json(
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
    @procedure_duration = ProcedureType.all.first.procedure_duration
  end

  def create
    @appointment = Appointment.new(appointments_params.merge({patient_id: current_user.id}))
    if @appointment.save
      redirect_to appointments_path, notice: 'La cita fue agendada correctamente'
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    if @appointment.destroy
      redirect_to appointments_path, notice: 'La cita fue eliminada correctamente.'
    end
  end

  private

  def appointments_params
    params.require(:appointment).permit(
      :appointment_datetime,
      :doctor_id,
      :procedure_type_id
    )
  end
end
