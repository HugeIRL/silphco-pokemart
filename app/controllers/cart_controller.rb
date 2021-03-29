class CartController < ApplicationController
  def create
    logger.debug("Adding #{params[:id]} to the shopping cart.")
    id = params[:id].to_i
    qty = params[:quantity].to_i
    session[:shopping_cart] << [id, qty]
    creature = Creature.find(id)
    flash[:notice] = "Added #{creature.species.titleize} to the cart."
    redirect_to root_path
  end

  def update
    logger.debug("Updated the amount of #{params[:id]} to #{params[:quantity]} in the cart.")
    id = params[:id].to_i
    qty = params[:quantity].to_i

    if !qty.zero?
      session[:shopping_cart].assoc(id)[1] = qty
      creature = Creature.find(id)
      flash[:notice] = "Updated the amount of #{creature.species.titleize} to #{qty} in your cart."
      redirect_to root_path
    else
      destroy
    end
  end

  def destroy
    logger.debug("Removing #{params[:id]} from the shopping cart.")
    id = params[:id].to_i
    session[:shopping_cart].delete(session[:shopping_cart].assoc(id))
    creature = Creature.find(id)
    flash[:alert] = "Removed #{creature.species.titleize} from the cart."
    redirect_to root_path
  end
end
