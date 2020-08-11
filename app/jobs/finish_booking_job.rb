class FinishBookingJob < ApplicationJob
	queue_as :default

	def perform(booking_id)
		booking = Rent.find(booking_id)
		if booking.status == "ongoing"
			booking.status = "finish"
			booking.save
		end
	end
end
