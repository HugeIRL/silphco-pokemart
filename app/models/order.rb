class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :creatures, join_table: "creature_orders"
end
