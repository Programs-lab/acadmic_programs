class WeeksWorker
  include Sidekiq::Worker

  def perform
    p "hello"
    week = nil
    new_week_attrs = {}
    working_days_attributes = {}
    working_hours_attributes = {}
    next_week = []

    User.where(role: :doctor).each do |u|
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
             working_hours_attributes[n]["initial_hour"] = DateTime.parse("#{day["working_date"].to_s} #{DateTime.parse(hour["initial_hour"].to_s).strftime("%H:%M%p")}")
             working_hours_attributes[n]["end_hour"] = DateTime.parse("#{day["working_date"].to_s} #{DateTime.parse(hour["end_hour"].to_s).strftime("%H:%M%p")}")
             working_days_attributes[i]["working_hours_attributes"] = {}
             working_days_attributes[i]["working_hours_attributes"][n] = working_hours_attributes[n]
          end          
        end

        new_week_attrs["working_days_attributes"] = working_days_attributes
        WorkingWeek.create(new_week_attrs)
        working_days_attributes = {}
        working_hours_attributes = {}
      end
    end

  end

end
