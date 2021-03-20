class User < ApplicationRecord
  validates :username, :email, :password, :address, :postal_code, presence: true
end
