class AcademicProgramsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_academic_program
  before_action :set_process_process_academic_program, only: [:show, :edit, :update, :destroy] 

  def index
    if params[:query] &&  params[:query] != ""
      @process_academic_programs = @academic_program.process_academic_programs.search_by_general_information(params[:query]).order(:code)
    else
      @process_academic_programs = @academic_program.process_academic_programs.order(:code)
    end
    authorize @academic_program
    @pagy, @process_academic_programs = pagy(@process_academic_programs)
  end

  def new
    @process_academic_program = @academic_program.process_academic_programs.new
    authorize @academic_program
  end

  def edit
    authorize @academic_program
  end

  def create
    @process_academic_program = @academic_program.process_academic_programs.new(process_academic_programs_params)
    authorize @academic_program

    respond_to do |format|
      if @process_academic_program.save
        format.html { redirect_to academic_program_process_academic_programs_path(@academic_program), notice: 'El programa fue creado exitosamente' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @academic_program

    respond_to do |format|
      if @process_academic_program.update(process_academic_programs_params)
        format.html { redirect_to academic_program_process_academic_programs_path(@academic_program), notice: 'El programa fue actualizado exitosamente' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
  authorize @academic_program
    @process_academic_program.destroy
    respond_to do |format|
      format.html { redirect_to academic_program_process_academic_programs_path(@academic_program), notice: 'El programa fue eliminado exitosamente' }
    end
  end

  private

  def set_academic_program
    @academic_program = Faculty.find(params[:academic_program_id])
  end

  def set_process_academic_program
    @process_academic_program = AcademicProgram.find(params[:id])
  end

  def process_academic_programs_params
    params.require(:process_academic_program).permit(:faculties_id, :name, :code, :email)
  end
end
