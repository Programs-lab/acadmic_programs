class Api::OneSignal::WebPushController < ApplicationController
  skip_before_action :verify_authenticity_token

  def event
    render json: { status: :ok }
  end
end