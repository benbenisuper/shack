class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  		:recoverable, :rememberable, :validatable
  has_many :bookings, dependent: :nullify
  has_many :reviews
  has_many :venues

  has_one_attached :avatar
  enum role: { guest: 0, host: 1, manager: 2, admin: 3 }
  
  def user_avatar
  	if self.avatar.attached?
  		self.avatar.key
  	else
  		"avatar"
  	end
  end

  def full_name
    return "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
