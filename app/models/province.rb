class Province < ApplicationRecord
  validates :name, :gst_rate, :pst_rate, :hst_rate, presence: true
  validates :gst_rate, :pst_rate, :hst_rate, numericality: { only_integer: true }
end
