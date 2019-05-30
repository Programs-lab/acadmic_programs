module AppointmentHelper

  def appointment_state(appointment)
    if appointment.appointment_datetime < DateTime.now && !appointment.completed?
      return ["Vencida", "badge-default"]
    else
      case appointment.state
      when "pending" then ["Pendiente", "badge-warning"]
      when "completed" then ["Completada", "badge-success"]
      when "canceled" then  ["Cancelada", "badge-danger "]
      end
    end      
  end

  def disabled_button(appointment)
    unless appointment.completed?
      "disabled-link"
    else
      ""
    end
  

  end

end
