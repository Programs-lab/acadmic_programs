class Api::MediaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Medium.where(medical_record_id: params[:id]).order(:created_at).to_json
  end

  def create
    @medium = Medium.new(file_name: params[:file], medical_record_id: params[:id])
    if @medium.save
      respond_to do |format|
        format.json{ render :json => @medium }
      end
    end
  end

  def destroy
    @medium = Medium.find(params[:id])
    @medium.destroy  
  end

end

