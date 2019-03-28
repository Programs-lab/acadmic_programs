class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected 

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :id_type, :id_number, :occupation, :address, :birthdate, :phone_number, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
  end

  private

  def user_not_authorized
    flash[:danger] = 'No se encuentra autorizado para completar esta acción'
    redirect_to root_path || request.referrer
  end

end
