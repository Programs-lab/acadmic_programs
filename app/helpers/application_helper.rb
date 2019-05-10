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
    case request.params[:controller]
    when 'admin/users' then 'active'
    when 'medical_records' then 'active'
    end
  end

  def is_appointment_path
    case request.path
    when '/pages/appointment' then 'active'
    when '/citas' then 'active'
    when '/pages/schedule_appointment' then 'active'
    end
  end

  def is_schedule_path
    case request.path
    when '/appointments/scheduled_appointments' then 'active'
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

  def testing
    week = nil
    new_week_attrs = {}
    working_days_attributes = {}
    working_hours_attributes = {}
    next_week = []

    User.where(role: :admin).each do |u|
      week = u.doctor_working_weeks.last
      if week
        new_week_attrs = week.attributes.except!("id", "created_at", "updated_at")
        new_week_attrs["initial_date"] = new_week_attrs["initial_date"].next_week
        new_week_attrs["end_date"] = new_week_attrs["end_date"].next_week.end_of_week - 2
        next_week = (new_week_attrs["initial_date"]..new_week_attrs["end_date"]).map.to_a

        week.working_days.each_with_index do |day, i|

          working_days_attributes[i] = day.attributes.except!("id", "created_at", "updated_at", "working_week_id")
          working_days_attributes[i]["working_date"] = next_week[i]

          day.working_hours.each_with_index do |hour, n|

             working_hours_attributes[n] = hour.attributes.except!("id", "created_at", "updated_at", "working_day_id")
             binding.pry
             working_hours_attributes[n]["initial_hour"] = DateTime.parse("#{day["working_date"].to_s} #{DateTime.parse(hour["initial_hour"].to_s).strftime("%H:%M%p")} -0500")
             working_hours_attributes[n]["end_hour"] = DateTime.parse("#{day["working_date"].to_s} #{DateTime.parse(hour["end_hour"].to_s).strftime("%H:%M%p")} -0500")
             working_days_attributes[i]["working_hours_attributes"] = {}
             working_days_attributes[i]["working_hours_attributes"][n] = working_hours_attributes[n]
          end
        end

        new_week_attrs["working_days_attributes"] = working_days_attributes
        #WorkingWeek.create(new_week_attrs)
        working_days_attributes = {}
        working_hours_attributes = {}
      end
    end
  end

  def disabled(user_disabled)
     user_disabled ? 'disabled_form' : ''
  end

  def disabled_button(user_disabled)
     user_disabled ? 'disabled' : ''
  end

end
