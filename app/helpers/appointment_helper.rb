module AppointmentHelper

  def process_state(process)
    if process
      if process + 1.month == Date.today
        ["Alerta", "badge-warning"]
      elsif process + 1.week == Date.today
          ["Alerta", "badge-warning"]
      elsif process <= Date.today
          ["Vencido", "badge-default"]
      else
          ["Vigente", "badge-success"]
      end
    else
      ["-", "badge-default"]
    end
  end

  def procedure_state(procedure)
    if procedure
      if procedure == 0
        ["Pendiente", "badge-warning"]
      elsif procedure == 1
        ["Cerrado", "badge-danger"]
      elsif procedure == 2
        ["Aprobado", "badge-success"]
      end
    else
      ["Pendiente", "badge-warning"]
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
