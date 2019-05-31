class AppointmentsMailer < ApplicationMailer

  include Routeable
  
  def canceled_appointment(user_id, appointment_id, reason=nil)
    @reason = reason
    @user = User.find(user_id)
    @appointment = Appointment.find(appointment_id)
    mail(to: @user.email, subject: "Cancelacion de cita")    
  end
end
