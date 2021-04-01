class SearchController < ApplicationController
  def search
    if params[:type].blank? && params[:species].blank?
      redirect_to(root_path) and return
    else
      @species = params[:species].downcase
      @type = params[:type].downcase
      if @species.blank?
        @results = Creature.joins(:type).all.where("lower(name) LIKE :type",
                                                   type: "%#{@type}%")
                           .page(params[:page]).per(6)
      elsif @type.blank?
        @results = Creature.joins(:type).all.where("lower(species) LIKE :species OR
                                                    lower(description) LIKE :species",
                                                   species: "%#{@species}%")
                           .page(params[:page]).per(6)
      else
        @results = Creature.joins(:type).all.where("lower(species) LIKE :species AND
                                                    lower(name) LIKE :type",
                                                   species: "%#{@species}%",
                                                   type:    "%#{@type}%")
                           .page(params[:page]).per(6)
      end
      redirect_to(root_path) and return if @results.blank?
    end
  end
end
