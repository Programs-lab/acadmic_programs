class UserPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def index?
    bt_administration_g
  end

  def doctors?
    bt_administration_g
  end

  def patients?
    is_doctor
  end

  def new?
    bt_administration_g
  end

  def create?
    bt_administration_g
  end

  def update?
    bt_administration_g
  end

  def destroy?
    bt_administration_g
  end

  private

  def bt_administration_g # Belongs to administration group
    @user.admin?
  end

  def is_doctor
    @user.admin? || @user.doctor?
  end
end
