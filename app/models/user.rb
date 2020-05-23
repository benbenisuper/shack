class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  		:recoverable, :rememberable, :validatable
  has_many :bookings, dependent: :nullify
  has_many :reviews
  has_many :venues

  has_one_attached :avatar

  def user_avatar
  	if self.avatar.attached?
  		self.avatar.key
  	else
  		"avatar"
  	end
  end

end
