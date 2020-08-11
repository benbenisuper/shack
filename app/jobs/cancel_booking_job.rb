class CancelBookingJob < ApplicationJob
	queue_as :default

	def perform(booking_id)
		booking = Rent.find(booking_id)
		if booking.status == "pending"
			booking.status = "cancelled"
			booking.save
		end
	end
end
