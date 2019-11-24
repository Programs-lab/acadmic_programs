class AcademicDepartmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_faculty
  before_action :set_academic_department, only: [:show, :edit, :update, :destroy] 

  def index
    if params[:query] &&  params[:query] != ""
      @academic_departments = @faculty.academic_departments.search_by_general_information(params[:query]).order(:code)
    else
      @academic_departments = @faculty.academic_departments.order(:code)
    end
    authorize @faculty
    @pagy, @academic_departments = pagy(@academic_departments)
  end

  def new
    @academic_department = @faculty.academic_departments.new
    authorize @faculty
  end

  def edit
    authorize @faculty
  end

  def create
    @academic_department = @faculty.academic_departments.new(academic_departments_params)
    authorize @faculty

    respond_to do |format|
      if @academic_department.save
        format.html { redirect_to faculty_academic_departments_path(@faculty), notice: 'El departamento fue creado exitosamente' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @faculty

    respond_to do |format|
      if @academic_department.update(academic_departments_params)
        format.html { redirect_to faculty_academic_departments_path(@faculty), notice: 'El departamento fue actualizado exitosamente' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
  authorize @faculty
    @academic_department.destroy
    respond_to do |format|
      format.html { redirect_to faculty_academic_departments_path(@faculty), notice: 'El departamento fue eliminado exitosamente' }
    end
  end

  private

  def set_faculty
    @faculty = Faculty.find(params[:faculty_id])
  end

  def set_academic_department
    @academic_department = AcademicDepartment.find(params[:id])
  end

  def academic_departments_params
    params.require(:academic_department).permit(:faculties_id, :code, :description)
  end
end
