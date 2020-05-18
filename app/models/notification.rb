class Notification < ApplicationRecord
  include CableReady::Broadcaster
  belongs_to :user
  validates :message, :title, presence: true

  enum state: [:unseen, :seen]
  
  after_create :send_notifications

  def send_notifications
    send_web_push_notification
    send_broadcast
  end
  
  def send_broadcast
    cable_ready["notification:#{user.id}"].remove_css_class(
      selector: "#notification_badge", 
      name: "hidden"
    )
    cable_ready.broadcast
  end
  
  def send_web_push_notification
    service = OneSignal::WebPushNotificationService.new(headings: title, contents: message)

    service.send_notification(email: user.email)
  end
end    