module ApplicationHelper

  def header(text)
    content_for(:header) { text.to_s }
  end

  def icon_alert
    {"alert" => "exclamation-triangle", "warning" => "exclamation-triangle", "notice" => "check-circle", "info" => "info-circle", "danger" => "", "success" => "check-circle", "danger" => "exclamation-circle"}
  end

  def is_users_path
    case request.params[:controller]
    when 'admin/users' then 'active'
    end
  end

  def is_doctors_path
    case request.params[:controller]
    when 'pages' then 'active'
    end
  end

  def is_companies_path
    case request.params[:controller]
    when 'companies' then 'active'
    end
  end


  def roles_names(user)
    if user.patient?
      "Paciente"
    elsif user.doctor?
      "Doctro"
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
