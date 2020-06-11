class Api::ProcedureDocumentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def fetch
    @procedure = Procedure.find(params[:id])
    render json: @procedure.procedure_documents.includes(:document).order("documents.name ASC").to_json(include: {comments: {include: {user: {only: [:id, :avatar, :first_name, :last_name]}}}})
  end

  def update
    @pd = ProcedureDocument.find(params[:id])
    @pd.update(procedure_document_file: params[:file], last_uploaded_file_date: Time.now)
  end

  def remove_file
    @pd = ProcedureDocument.find(params[:id])
    @pd.remove_procedure_document_file = true
    @pd.save!
  end

  def add_comment
    @pd = ProcedureDocument.find(params[:id])
    @user = User.find(params[:user_id])
    @pd.comments.create(
      content: params[:content],
      user_id: params[:user_id]
      )
    @pd.procedure.processes_academic_program.academic_program.users.last.notifications.create(
        title: "Nueba observacion",
        message: "El usuario #{@user.first_name} #{@user.last_name} ha dejado una observacion en el documento: #{@pd.document.name} para el proceso de #{@pd.procedure.processes_academic_program.academic_process.name} en el tramite de #{@pd.procedure.procedure_date.strftime("%Y/%m/%d ")}",
        launch: faculty_academic_program_process_academic_program_procedure_procedure_documents_path(
          faculty_id: @pd.procedure.processes_academic_program.academic_program.faculty.id,
          academic_program_id: @pd.procedure.processes_academic_program.academic_program.id,
          process_academic_program_id: @pd.procedure.processes_academic_program.id,
          procedure_id: @pd.procedure.id)
        )
      NotificationsMailer.new_notification(@user.id, @user.notifications.last.id).deliver_now()
  end

  def remove_comment
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  def destroy
    @medium = Medium.find(params[:id])
    @medium.destroy
  end

end

