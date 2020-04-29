class AcademicProcessesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_process, only: [:edit, :update, :destroy, :documents]
  def index
    if params[:query] &&  params[:query] != ""
      @academic_processes = AcademicProcess.search_by_general_information(params[:query]).order(:name)
    else
      @academic_processes = AcademicProcess.all.order(:name)
    end
    authorize @academic_processes
    @pagy, @academic_processes = pagy(@academic_processes)
  end

  def new
    @academic_process = AcademicProcess.new
    authorize @academic_process
  end

  def edit
    authorize @academic_process
  end

  def create
    @academic_process = AcademicProcess.new(academic_process_params)
    authorize @academic_process
    if @academic_process.save
      redirect_to academic_processes_path, notice: 'El proceso ha sido creada exitodamente'
    else
      redirect_to academic_processes_path, alert: 'El proceso no pudo ser creada'
    end
  end

  def update
    authorize @academic_process
    if @academic_process.update(academic_process_params)
      redirect_to academic_processes_path, notice: 'El proceso fue actualizada exitosamente.'
    else
      redirect_to academic_processes_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end

  def documents
    authorize @academic_process
  end

  def destroy
    authorize @academic_process
    if @academic_process.destroy
      redirect_to academic_processes_path, notice: 'El proceso fue eliminada correctamente.'
    end
  end

  private

  def set_process
    @academic_process = AcademicProcess.find(params[:id] || params[:academic_process_id])
  end

  def academic_process_params
    params.require(:academic_process).permit(:id, :name, :year_saces, :month_saces, :day_saces, :year_academic_council, :month_academic_council, :day_academic_council, documents_attributes: [:id, :name, :description, :template, :_destroy])
  end

end
