module ApplicationHelper
  include Pagy::Frontend

  def header(text)
    content_for(:header) { text.to_s }
  end

  def icon_alert
    {"alert" => "exclamation-triangle", "warning" => "exclamation-triangle", "notice" => "check-circle", "info" => "info-circle", "danger" => "", "success" => "check-circle", "danger" => "exclamation-circle"}
  end

  def is_users_path
    case request.params[:controller]
    when 'admin/users' then 'active' if request.params[:action] == 'index' ||  request.params[:action] == 'new' || request.params[:action] == 'edit'
    end
  end

  def is_patients_path
    case request.params[:controller]
    when 'admin/users' then 'active' if request.params[:action] == 'patients'
    when 'medical_records' then 'active' if request.params[:action] == 'medical_record'
    when 'appointments' then 'active' if request.params[:action] == 'schedule_appointment'
    end
  end

  def is_appointment_path
    case request.path
    when '/pages/appointment' then 'active'
    when '/citas' then 'active'
    when '/citas/new' then 'active'
    when '/pages/schedule_appointment' then 'active'
    end
  end

  def is_faculty_path
    case request.params[:controller]
    when 'faculties' then 'active'
    when 'process_academic_programs' then 'active'
    when 'academic_programs' then 'active'
    when 'academic_departments' then 'active'
    when 'procedures' then 'active'
    end
  end

  def is_processes_path
    case request.params[:controller]
    when 'academic_processes' then 'active'
    end
  end

  def is_medical_record_path
    case request.path
    when '/historial_medico' then 'active'
    end
  end

  def is_schedule_path
    state = ''
    case request.path
    when '/appointments/scheduled_appointments' then state = 'active'
    when '/citas/todas' then state ='active'
    end
    if request.params[:action] == 'summary' && request.params[:controller] == 'appointments'
      state = 'active'
    end
    state
  end

  def is_doctors_path
     case request.params[:controller]
        when 'admin/users' then 'active' if request.params[:action] == 'doctors'
     end
  end

  def is_patient_medical_record_path
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
    if user.director?
      "Director"
    else
      "Administrador"
    end
  end

  def modlities_names(user)
    case user.modality
    when "mag" then "Maestria"
    when "preg" then "Pregrado"
    when "esp" then "Especialidad"
    when "doc" then "Doctorado"
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

  def disabled_user_button(user_disabled)
     user_disabled ? 'disabled' : ''
  end

end
