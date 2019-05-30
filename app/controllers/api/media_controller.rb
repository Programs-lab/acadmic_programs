class Api::MediaController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    @medium = Medium.new(file_name: params[:file], appointment_report_id: params[:id])
    respond_to do |format|
      format.json{ render :json => @media }
    end
  end
end

