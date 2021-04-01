class Type < ApplicationRecord
  has_many :creatures

  validates :name, presence: true

  def capitalized_name
    name.capitalize
  end

  def badge(type)
    @badge = if !Rails.application.assets.find_asset("#{type}.png").nil?
               "#{type}.png"
             else
               "unknown.png"
             end
  end
end
