class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, :last_name, :email, :encrypted_password, :address, :postal_code,
            presence: true

  belongs_to :province
  belongs_to :city

  has_many :orders, dependent: :destroy
  has_many :creatures, through: :orders
end
