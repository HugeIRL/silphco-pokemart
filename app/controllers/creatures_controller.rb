class CreaturesController < ApplicationController
  def index
    @creatures = if params[:type_id].blank?
                   Creature.with_attached_image.includes(:type).page(params[:page])
                 else
                   Creature.with_attached_image.includes(:type).where(type_id: params[:type_id])
                           .page(params[:page])
                 end
  end

  def show
    @creature = Creature.with_attached_image.find(params[:id])
  end
end
