class AppointmentWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    appointments = user.patient_appointments.where(state: :disabled)
    if appointments.any?
      appointments.each do |app|
        app.destroy
      end
    end
  end
end
