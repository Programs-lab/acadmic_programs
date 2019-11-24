class AcademicProgramsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_faculty
  before_action :set_academic_program, only: [:show, :edit, :update, :destroy] 

  def index
    if params[:query] &&  params[:query] != ""
      @academic_programs = @faculty.academic_programs.search_by_general_information(params[:query]).order(:code)
    else
      @academic_programs = @faculty.academic_programs.order(:code)
    end
    authorize @faculty
    @pagy, @academic_programs = pagy(@academic_programs)
  end

  def new
    @academic_program = @faculty.academic_programs.new
    authorize @faculty
  end

  def edit
    authorize @faculty
  end

  def create
    @academic_program = @faculty.academic_programs.new(academic_programs_params)
    authorize @faculty

    respond_to do |format|
      if @academic_program.save
        format.html { redirect_to faculty_academic_programs_path(@faculty), notice: 'El programa fue creado exitosamente' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @faculty

    respond_to do |format|
      if @academic_program.update(academic_programs_params)
        format.html { redirect_to faculty_academic_programs_path(@faculty), notice: 'El programa fue actualizado exitosamente' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
  authorize @faculty
    @academic_program.destroy
    respond_to do |format|
      format.html { redirect_to faculty_academic_programs_path(@faculty), notice: 'El programa fue eliminado exitosamente' }
    end
  end

  private

  def set_faculty
    @faculty = Faculty.find(params[:faculty_id])
  end

  def set_academic_program
    @academic_program = AcademicProgram.find(params[:id])
  end

  def academic_programs_params
    params.require(:academic_program).permit(:faculties_id, :name, :code, :email)
  end
end
