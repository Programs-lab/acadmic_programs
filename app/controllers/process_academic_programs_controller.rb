class ProcessAcademicProgramsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_faculty
  before_action :set_academic_program
  before_action :set_process_academic_program, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query] &&  params[:query] != ""
      @processes_academic_programs = @academic_program.processes_academic_programs.search_by_general_information(params[:query])
    else
      @processes_academic_programs = @academic_program.processes_academic_programs
    end
    @pagy, @processes_academic_programs = pagy(@processes_academic_programs)
  end

  def new
    @process_academic_program = @academic_program.processes_academic_programs.new
    authorize @faculty
  end

  def edit
  end

  def create
    @process_academic_program = @academic_program.processes_academic_programs.new(process_academic_programs_params)

    respond_to do |format|
      if @process_academic_program.save
        format.html { redirect_to faculty_academic_program_process_academic_programs_path(@academic_program), notice: 'El programa fue creado exitosamente' }
      else
        format.html { render :new }
      end
    end
  end

  def update

    respond_to do |format|
      if @process_academic_program.update(process_academic_programs_params)
        format.html { redirect_to faculty_academic_program_process_academic_program_procedures_path(faculty_id: @faculty.id, academic_program_id: @process_academic_program.academic_program.id, process_academic_program_id: @process_academic_program.id), notice: 'Resolucion agregada con exito' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @process_academic_program.destroy
    respond_to do |format|
      format.html { redirect_to academic_program_process_academic_programs_path(@academic_program), notice: 'El programa fue eliminado exitosamente' }
    end
  end

  private

  def set_faculty
    @faculty = Faculty.find(params[:faculty_id])
  end

  def set_academic_program
    @academic_program = @faculty.academic_programs.find(params[:academic_program_id])
  end

  def set_process_academic_program
    @process_academic_program = ProcessesAcademicProgram.find(params[:id])
  end

  def process_academic_programs_params
    params.require(:processes_academic_program).permit(:men_date, :resolution, :validity)
  end
end
