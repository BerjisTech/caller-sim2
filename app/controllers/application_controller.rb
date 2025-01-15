# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include RackSessionsFix
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[nying lela_wang pacho dhok])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[nying lela_wang pacho dhok])
  end
end
