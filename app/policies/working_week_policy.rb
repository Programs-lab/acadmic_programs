class WorkingWeekPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def index?
    bt_administration_g
  end

  def create?
    bt_administration_g
  end

  def update?
    bt_administration_g
  end

  def update_all?
    bt_administration_g
  end

  private

  def bt_administration_g # Belongs to administration group
    @user.admin? || @user.doctor?
  end

end