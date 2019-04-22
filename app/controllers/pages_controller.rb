class PagesController < ApplicationController
  before_action :authenticate_user!, except: :schedule_appointment_no_user
  def home
  end

  def medical_record
  end

  def schedule_appointment_no_user
  end
end
