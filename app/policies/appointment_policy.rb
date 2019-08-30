class AppointmentPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def index?
    is_patient
  end

  def new?
    is_patient
  end

  def create?
    is_patient
  end

  def scheduled_appointments?
    is_doctor
  end

  def all_appointments?
    is_admin    
  end

  def attend_appointment?
    is_admin
  end

  private

  def is_admin
    @user.admin?
  end

  def is_doctor
    @user.doctor?
  end

  def is_patient
    @user.patient?
  end
end
