class CreaturesController < ApplicationController
  def index
    @creatures = Creature.includes(:type).page(params[:page]).per(12)
  end

  def show
    @creature = Creature.find(params[:id])
  end
end
