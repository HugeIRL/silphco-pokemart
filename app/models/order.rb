class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :creatures, join_table: "creature_orders"

  validates :pst_rate, :gst_rate, :hst_rate, presence: true
  validates :pst_rate, :gst_rate, :hst_rate, numericality: { only_float: true }
end
