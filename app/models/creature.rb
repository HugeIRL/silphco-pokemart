class Creature < ApplicationRecord
  validates :pokedex_id, :species, :description, :price_cents, presence: true
  validates :pokedex_id, :price_cents, numericality: { only_integer: true }
end
