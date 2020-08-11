class StartBookingJob < ApplicationJob
	queue_as :default

	def perform(booking_id)
		booking = Rent.find(booking_id)
		if booking.status == "approved"
			booking.status = "ongoing"
			booking.save
		end
	end
end
