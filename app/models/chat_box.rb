class ChatBox < ApplicationRecord
	has_many :messages, dependent: :destroy
	belongs_to :booking
	has_many :users, through: :booking

	def host
		booking.venue.user
	end

	def guest
		booking.user
	end

	def new_messages
		messages.where.not(user: self).where("created_at > ?", Time.now - 10.day)
	end
end
