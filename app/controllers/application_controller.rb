class ApplicationController < ActionController::Base
  layout :specify_layout
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  # Show main layout unless signed out, in which case use sign in layout
  def specify_layout
    if devise_controller?
      if !(current_user.nil?)
        "application"
      else
        "sign_in"
      end
    else
      "application"
    end
  end
end
