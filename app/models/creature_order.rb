class CreatureOrder < ApplicationRecord
  belongs_to :order
  belongs_to :creature
end
