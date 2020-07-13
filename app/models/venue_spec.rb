class VenueSpec < ApplicationRecord
	belongs_to :venue

	validates :total_area, presence: true
	validates :spaces, presence: true
	validates :bathrooms, presence: true
	validates :garage_spaces, presence: true
end
