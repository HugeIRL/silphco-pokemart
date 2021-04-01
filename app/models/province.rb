class Province < ApplicationRecord
  validates :name, :gst_rate, :pst_rate, :hst_rate, presence: true
  validates :pst_rate, :gst_rate, :hst_rate, numericality: { only_float: true }

  has_many :cities, dependent: :destroy
  has_many :users, dependent: :destroy
end
