class CheckoutController < ApplicationController
  def create
    @creature = Creature.find(params[:creature_id])

    if @creature.nil?
      redirect_to root_path
      return
    end

    respond_to do |format|
      format.js
    end
  end

  def success
    # do stuff
  end

  def cancel
    # do more stuff
  end
end
