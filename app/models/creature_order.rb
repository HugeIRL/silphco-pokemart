class CreatureOrder < ApplicationRecord
  belongs_to :order
  belongs_to :creature

  validates :quantity, :purchase_price, presence: true
  validates :quantity, :purchase_price, numericality: { only_integer: true }
end
