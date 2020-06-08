class NotificationsMailer < ApplicationMailer

  include Routeable

  def new_notification(user_id, notification_id)
    @user = User.find(user_id)
    @notification = @user.notifications.find(notification_id)
    mail(to: @user.email, subject: "#{@notification.title}")
  end
end
