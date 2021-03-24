class CreatureOrder < ApplicationRecord
  belongs_to :order
  belongs_to :creature

  validates :quantity, presence: true
  validates :quantity, numericality: { only_integer: true }
end
