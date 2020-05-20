class Notification < ApplicationRecord
  include CableReady::Broadcaster
  belongs_to :user
  validates :message, :title, presence: true

  enum state: [:unseen, :seen]
  
  after_create :send_notifications
  after_update :broadcast_to_seen_notifications, unless: Proc.new { user.notifications.unseen.present? }

  def send_notifications
    send_web_push_notification
    broadcast_to_unseen_notifications
  end
  
  def broadcast_to_unseen_notifications
    cable_ready["notification:#{user.id}"].remove_css_class(
      selector: "#notification_badge", 
      name: "hidden"
    )
    cable_ready.broadcast
  end
  
  def broadcast_to_seen_notifications
    cable_ready["notification:#{user.id}"].add_css_class(
      selector: "#notification_badge", 
      name: "hidden"
    )
    cable_ready.broadcast
  end

  def send_web_push_notification
    url = Rails.application.routes.url_helpers.user_notifications_redirect_path(self)

    service = OneSignal::WebPushNotificationService.new(headings: title, contents: message, url: url)

    service.send_notification(email: user.email)
  end
end    