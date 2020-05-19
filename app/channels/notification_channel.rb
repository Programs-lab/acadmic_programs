class NotificationChannel < ApplicationCable::Channel
  def subscribed
    # Save online status
    stream_from "notification:#{current_user.id}"
  end

  def unsubscribed
    # Remove online status
  end
end
