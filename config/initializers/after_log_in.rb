Warden::Manager.after_authentication do |user,auth,opts|
  if user.patient?

    appointments = user.patient_appointments.where(state: :disabled)
    if appointments.any?
      appointments.each do |app|
        app.update(state: :pending)
      end
    end
  end
end
