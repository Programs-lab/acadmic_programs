class Api::AcademicProgramsController < ApplicationController

  def fetch_academic_programs
    faculty = Faculty.find(params[:faculty_id])  
    @academic_programs = faculty.academic_programs.select(:id, :name)
    render json: @academic_programs.to_json
  end

end
