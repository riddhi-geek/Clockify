class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def missing_path
		redirect_to(
			root_path,
			alert: 'Path that you were looking does not belong to us!'
		)
	end

	protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.permit :sign_up, keys: [:name, :username, :email, :password, :password_confirmation]
		devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password, :password_confirmation]
  end
end
