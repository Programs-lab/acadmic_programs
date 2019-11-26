class Api::MediaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Medium.where(processes_academic_program_id: params[:id]).order(:created_at).to_json
  end

  def create
    @medium = Medium.new(file_name: params[:file], processes_academic_program_id: params[:id])
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

