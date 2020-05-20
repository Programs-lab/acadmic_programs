class ProceduresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pr_academic_program
  before_action :set_procedure, only: [:show, :edit, :update, :destroy, :procedure_documents, :close_procedure, :complete_procedure, :request_approval, :request_document]

  def index
    @current_procedure = @pr_academic_program.procedures.where(state: 0)
    if params[:query] &&  params[:query] != ""
      @procedures = @pr_academic_program.procedures.search_by_general_information(params[:query]).order(:procedure_date)
    else
      @procedures = @pr_academic_program.procedures.where.not(state: 0).order(:procedure_date)
    end
    @procedure = @pr_academic_program.procedures.new
    @pagy, @procedures = pagy(@procedures, items: 5)
  end

  def new
    @procedure = @pr_academic_program.procedures.new
  end

  def edit
  end

  def procedure_documents
    @documents = @procedure.procedure_documents
  end

  def close_procedure
    @procedure.update(state: 1, closed_date: Date.today)
    redirect_to faculty_academic_program_process_academic_program_procedures_path(faculty_id: @faculty.id, academic_program_id: @pr_academic_program.academic_program.id, process_academic_program_id: @pr_academic_program.id)
    @pr_academic_program.academic_program.users.last.notifications.create(
        title: "Tramite cerrado",
        message: "El tramite de fecha #{@procedure.procedure_date} del proceso #{pr_academic_program.academic_process.name} fue cerrado",
        launch: faculty_academic_program_process_academic_program_procedures_path(
          faculty_id: @faculty.id,
          academic_program_id: @pr_academic_program.academic_program.id,
          process_academic_program_id: @pr_academic_program.id
          )
        )
  end

  def complete_procedure
    @procedure.update(state: 2, closed_date: Date.today)
    @pr_academic_program.academic_program.users.last.notifications.create(
        title: "Tramite aprobado",
        message: "El tramite de fecha #{@procedure.strftime("%Y/%m/%d ")} del proceso #{pr_academic_program.academic_process.name} fue aprobado",
        launch: faculty_academic_program_process_academic_program_procedures_path(
          faculty_id: @faculty.id,
          academic_program_id: @pr_academic_program.academic_program.id,
          process_academic_program_id: @pr_academic_program.id
          )
        )
    redirect_to faculty_academic_program_process_academic_program_procedures_path(faculty_id: @faculty.id, academic_program_id: @pr_academic_program.academic_program.id, process_academic_program_id: @pr_academic_program.id)
  end

  def request_approval
    User.where(role: :admin).each do |u|
      u.notifications.create(
        title: "Solicitud de revision",
        message: "El director de programa de #{@pr_academic_program.academic_program.name} ha solicitado la revision del tramite con fecha #{@procedure.procedure_date.strftime("%Y/%m/%d ")}",
        launch: "#{faculty_academic_program_process_academic_program_procedure_procedure_documents_path(faculty_id: @faculty.id, academic_program_id: @pr_academic_program.academic_program.id, process_academic_program_id: @pr_academic_program.id, procedure_id: @procedure.id)}")
    end
    redirect_to faculty_academic_program_process_academic_program_procedure_procedure_documents_path(faculty_id: @faculty.id, academic_program_id: @pr_academic_program.academic_program.id, process_academic_program_id: @pr_academic_program.id, procedure_id: @procedure.id), notice: 'Se solicito la revision de documentos'
  end

  def request_document
    document = @procedure.procedure_documents.find(params[:document_id]).document
    @pr_academic_program.academic_program.users.last.notifications.create(
        title: "Peticion de documento",
        message: "Se ha solicitado que se suba el documento #{document.name} para el proceso de #{@pr_academic_program.academic_process.name} en el tramite de #{@procedure.procedure_date.strftime("%Y/%m/%d ")}",
        launch: faculty_academic_program_process_academic_program_procedure_procedure_documents_path(
          faculty_id: @faculty.id,
          academic_program_id: @pr_academic_program.academic_program.id,
          process_academic_program_id: @pr_academic_program.id,
          procedure_id: @procedure.id)
        )
     redirect_to faculty_academic_program_process_academic_program_procedure_procedure_documents_path(faculty_id: @faculty.id, academic_program_id: @pr_academic_program.academic_program.id, process_academic_program_id: @pr_academic_program.id, procedure_id: @procedure.id), notice: 'Se solicito el documento'
  end

  def create
    @procedure = @pr_academic_program.procedures.new(procedure_params)
    respond_to do |format|
      if @procedure.save
        format.html { redirect_to faculty_academic_program_process_academic_program_procedure_procedure_documents_path(faculty_id: @faculty.id, academic_program_id: @pr_academic_program.academic_program.id, process_academic_program_id: @pr_academic_program.id, procedure_id: @procedure.id), notice: 'El tramite fue creado exitosamente'}
      else
        format.html { redirect_to faculty_academic_program_process_academic_program_procedures_path(faculty_id: @faculty.id, academic_program_id: @pr_academic_program.academic_program.id, process_academic_program_id: @pr_academic_program.id), alert: "El tramite no pudo ser creado" }
      end
    end
  end

  def update
    respond_to do |format|
      if @procedure.update(procedure_params)
        format.html { redirect_to faculty_academic_program_process_academic_program_procedure_path(@faculty, @pr_academic_program.academic_program, @procedure), notice: 'El programa fue actualizado exitosamente' }
      else
        format.html { redirect_to faculty_academic_program_process_academic_program_procedures_path(@faculty, @pr_academic_program.academic_program) }
      end
    end
  end

  def destroy
    @procedure.destroy
    respond_to do |format|
      format.html { redirect_to faculty_academic_programs_path(@faculty), notice: 'El programa fue eliminado exitosamente' }
    end
  end

  private

  def set_pr_academic_program
    @pr_academic_program = ProcessesAcademicProgram.find(params[:process_academic_program_id])
    @faculty = Faculty.find(@pr_academic_program.academic_program.faculty.id)
  end

  def set_procedure
    @procedure = Procedure.find(params[:id] || params[:procedure_id])
  end

  def procedure_params
    params.require(:procedure).permit(:procedure_date, :processes_academic_program_id)
  end
end
