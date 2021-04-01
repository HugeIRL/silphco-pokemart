class SearchController < ApplicationController
  def search
    redirect_to(root_path) if params[:species].blank?
    @results = change_output(params[:species], params[:type]).page(params[:page])
    redirect_to(root_path) and return if @results.blank?
  end

  def change_output(species, type)
    return unless species.downcase.nil? == false

    Creature.joins(:type).all.where("lower(name) LIKE :type",
                                    type: "%#{type}%")

    return unless type.downcase.nil? == false

    Creature.joins(:type).all.where("lower(species) LIKE :species OR
                                          lower(description) LIKE :species",
                                    species: "%#{species}%")
  end
end
