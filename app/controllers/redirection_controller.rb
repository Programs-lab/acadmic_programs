class RedirectionController < ApplicationController
  before_action :authenticate_user!

  def index
    path = case current_user.role
     when 'director'
      faculty_academic_program_process_academic_programs_path(current_user.academic_program.faculty, current_user.academic_program)
     when 'doctor'
      scheduled_appointments_path
     when 'admin'     
      admin_users_path
     else
      destroy_user_session_path
      flash[:danger] = 'Hubo un problema con el inicio de sesion por favor comuniquese con el equipo de desarrollo'
    end
    redirect_to path
  end
end
