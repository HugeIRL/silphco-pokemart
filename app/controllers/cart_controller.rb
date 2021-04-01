class CartController < ApplicationController
  def create
    id = params[:id].to_i
    qty = params[:quantity].to_i
    session[:shopping_cart] << [id, qty]
    flash[:notice] = "Added to your bag."
    redirect_to root_path
  end

  def update
    id = params[:id].to_i
    qty = params[:quantity]
    valid?(qty, id)
    session[:shopping_cart].assoc(id)[1] = qty
    flash[:notice] = "Your bag has been updated."
    redirect_to root_path
  end

  def destroy
    id = params[:id].to_i
    session[:shopping_cart].delete(session[:shopping_cart].assoc(id))
    flash[:alert] = "Removed from your bag."
    redirect_to root_path
  end

  def valid?(quantity, id)
    destroy unless quantity.to_i.is_a? Integer
    destroy unless id.to_i.is_a? Integer
    redirect_to root_path and destroy if id.to_i.zero? || quantity.to_i.zero?
  end
end
