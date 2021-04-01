class CreaturesController < ApplicationController
  def index
    if params[:type_id].blank?
      @creatures = Creature.includes(:type).page(params[:page]).per(12)
    else
      @creatures = Creature.includes(:type).where(type_id: params[:type_id]).page(params[:page]).per(12)
    end
  end

  def show
    @creature = Creature.find(params[:id])
  end
end
