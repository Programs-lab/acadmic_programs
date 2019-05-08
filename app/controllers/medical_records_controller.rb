class MedicalRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient

  def medical_record
    @appointment_reports = @patient.medical_record ? @patient.medical_record.appointment_reports : []
  end

  private

  def set_patient
    @patient = User.find(params[:patient_id])
  end
end
