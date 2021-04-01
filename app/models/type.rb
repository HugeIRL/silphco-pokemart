class Type < ApplicationRecord
  has_many :creatures

  validates :name, presence: true

  def capitalized_name
    name.capitalize
  end
end
