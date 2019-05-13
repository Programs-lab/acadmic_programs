class AppointmentReportPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def index?
    is_patient
  end

  def medical_record?
    is_doctor
  end

  private

  def is_doctor
    @user.doctor?
  end

  def is_patient
    @user.patient?
  end
end
