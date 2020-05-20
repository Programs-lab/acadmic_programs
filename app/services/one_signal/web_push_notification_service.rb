module OneSignal
  class WebPushNotificationService
    def initialize(headings: "", contents: "", url: "")
      @client = OneSignal::Client.new(auth_token: Rails.application.secrets.onesignal_app_key, app_id: Rails.application.secrets.onesignal_app_id)
      @headings = headings
      @contents = contents
      @url = url
    end

    def filter_by_email(email)
      { 
        headings: { en: @headings },
        contents: { en: @contents }, 
        filters: [{:field=>"email", :value=> email}],
        url: @url
      }
    end  

    def send_notification(email: "")
      @client.notifications.create(filter_by_email(email))
    end

    def fetch_subscribed_users
      @client.players.all
    end
  end
end

