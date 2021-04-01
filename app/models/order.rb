class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :creatures, join_table: "creature_orders"

  validates :pst_rate, :gst_rate, :hst_rate, :total_cost, :payment_status, :payment_intent,
            :user_id, presence: true
  validates :pst_rate, :gst_rate, :hst_rate, numericality: { only_float: true }
  validates :total_cost, numericality: { only_integer: true }

  paginates_per 6
end
