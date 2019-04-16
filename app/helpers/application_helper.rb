module ApplicationHelper

  def header(text)
    content_for(:header) { text.to_s }
  end

  def icon_alert
    {"alert" => "exclamation-triangle", "warning" => "exclamation-triangle", "notice" => "check-circle", "info" => "info-circle", "danger" => "", "success" => "check-circle", "danger" => "exclamation-circle"}
  end

  def is_users_path
    case request.path
    when '/admin/usuarios' then 'active'
    when '/' then 'active'
    end
  end

  def is_patients_path
    case request.path
    when '/admin/pacientes' then 'active'
    when '/pages/medical_record' then 'active'    
    end
  end

  def is_doctors_path
    case request.path
    when '/admin/doctores' then 'active'
    end
  end

  def is_medical_record_path
    case request.path
    when '/pages/medical_record' then 'active'
    end
  end


  def is_companies_path
    case request.params[:controller]
    when 'companies' then 'active'
    end
  end

  def is_working_week_path
    case request.params[:controller]
    when 'working_weeks' then 'active'
    end
  end

  def is_procedure_type_path
    case request.params[:controller]
    when 'procedure_types' then 'active'
    end
  end

  def roles_names(user)
    if user.patient?
      "Paciente"
    elsif user.doctor?
      "Doctor"
    else
      "Administrador"
    end
  end

  def disabled(user_disabled)
     user_disabled ? 'disabled_form' : ''
  end

  def disabled_button(user_disabled)
     user_disabled ? 'disabled' : ''
  end

end
