class Type < ApplicationRecord
  has_many :creatures

  validates :name, presence: true
end
