class OrdersController < ApplicationController
  def index
    if current_user
      @orders = Order.includes(:user).where(user_id: current_user.id).page(params[:page]).per(6)
    else
      redirect_to root_path
    end
  end
end
