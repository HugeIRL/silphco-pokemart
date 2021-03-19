class CreaturesController < ApplicationController
  def index
    @creatures = Creature.includes(:type).all
  end

  def show
    @creature = Creature.find(params[:id])
  end
end
