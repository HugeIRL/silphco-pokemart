class ApplicationController < ActionController::Base
  before_action :initialize_session
  helper_method :cart

  private

  def initialize_session
    session[:shopping_cart] ||= []
  end

  def cart
    Creature.find(session[:shopping_cart])
  end

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :address, :province_id, :postal_code, :email, :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :address, :province_id, :postal_code, :email, :password,
               :current_password)
    end
  end
end
