class Creature < ApplicationRecord
  belongs_to :type

  validates :pokedex_id, :species, :description, :price_cents, presence: true
  validates :pokedex_id, :price_cents, numericality: { only_integer: true }

  has_one_attached :image, dependent: :destroy

  has_and_belongs_to_many :orders, join_table: "creature_orders"
end
