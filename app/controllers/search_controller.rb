class SearchController < ApplicationController
  def search
    results = change_output(params[:species], params[:type])
    validate(results)
  end

  def change_output(species, type)
    if species.blank? && type.blank?
      nil
    elsif species.blank?
      display_by_type(type)
    elsif type.blank?
      display_by_name_or_desc(species)
    else
      display_by_any(species, type)
    end
  end

  def display_by_type(type)
    Creature.joins(:type).all.where("lower(name) LIKE :type",
                                    type: "%#{type}%")
            .page(params[:page])
  end

  def display_by_name_or_desc(species)
    @results = Creature.joins(:type).all.where("lower(species) LIKE :species OR
    lower(description) LIKE :species",
                                               species: "%#{species}%")
                       .page(params[:page])
  end

  def display_by_any(species, type)
    Creature.joins(:type).all.where("lower(species) LIKE :species AND
    lower(name) LIKE :type",
                                    species: "%#{species}%",
                                    type:    "%#{type}%")
            .page(params[:page]).per(6)
  end

  def validate(results)
    message = "No result found for '#{params[:species]}' with type: '#{params[:type]}'"
    redirect_to(root_path) and flash[:alert] = message if results.blank?
  end
end
