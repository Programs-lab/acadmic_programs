class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
  end

  def medical_record
  end
end
