class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:edit, :update, :destroy]
  def index
    @notifications = current_user.notifications.all.order(:created_at)
    @pagy, @notifications = pagy(@notifications)
  end

  def destroy
    @notifcation = Notification.find(params[:id])
    if @notification.delete
      redirect_to notifications_path
    end
  end

  def redirect
    @notification = Notification.find(params[:id])
    @notification.update(state: :seen)
    redirect_to @notification.launch
  end
end
