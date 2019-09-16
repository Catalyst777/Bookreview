class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    has_secure_password

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
end
