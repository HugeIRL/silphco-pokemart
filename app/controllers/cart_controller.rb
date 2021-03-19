class CartController < ApplicationController
  def create
    logger.debug("Adding #{params[:id]} to the shopping cart.")
    id = params[:id].to_i
    session[:shopping_cart] << id
    creature = Creature.find(id)
    flash[:notice] = "Added #{creature.species.titleize} to the cart."
    redirect_to root_path
  end

  def destroy
    logger.debug("Removing #{params[:id]} from the shopping cart.")
    id = params[:id].to_i
    session[:shopping_cart].delete(id)
    creature = Creature.find(id)
    flash[:notice] = "Removed #{creature.species.titleize} from the cart."
    redirect_to root_path
  end
end
