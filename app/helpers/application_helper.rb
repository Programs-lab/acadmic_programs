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

  def roles_names(user)
    if user.patient?
      "Paciente"
    end
  end

end
