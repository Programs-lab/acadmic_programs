class FacultiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_faculty, only: [:edit, :update, :destroy]
  def index
    if params[:query] &&  params[:query] != ""
      @faculties = Faculty.search_by_general_information(params[:query]).order(:code)
    else
      @faculties = Faculty.all.order(:code)
    end
    authorize @faculties
    @pagy, @faculties = pagy(@faculties)
  end

  def new
    @faculty = Faculty.new
    authorize @faculty
  end

  def edit    
    authorize @faculty
  end

  def create
    @faculty = Faculty.new(faculty_params)
    authorize @faculty
    if @faculty.save
      redirect_to faculties_path, notice: 'La facultad ha sido creada exitodamente'
    else
      redirect_to faculties_path, alert: 'La facultad no pudo ser creada'
    end    
  end

  def update
    authorize @faculty
    if @faculty.update(procedure_type_params)
      redirect_to faculties_path, notice: 'La facultad fue actualizada exitosamente.'
    else
      redirect_to faculties_path, alert: 'No fue posible concretar el registro, por favor revise los campos nuevamente'
    end
  end

  def destroy
    authorize @faculty
    if @faculty.destroy
      redirect_to faculties_path, notice: 'La facultad fue eliminada correctamente.'
    end
  end

  private

  def set_faculty
    @faculty = Faculty.find(params[:id] || params[:procedure_type_id])
  end

  def faculty_params
    params.require(:faculty).permit(:name, :code)
  end

end
