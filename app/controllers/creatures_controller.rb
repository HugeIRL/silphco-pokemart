class CreaturesController < ApplicationController
  def index
    @creatures = if params[:type_id].blank?
                   Creature.with_attached_image.includes(:type).page(params[:page]).per(12)
                 else
                   Creature.with_attached_image.includes(:type).where(type_id: params[:type_id]).page(params[:page]).per(12)
                 end
  end

  def show
    @creature = Creature.with_attached_image.find(params[:id])
  end
end
