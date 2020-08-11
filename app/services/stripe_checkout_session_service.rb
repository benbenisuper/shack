class StripeCheckoutSessionService
  def call(event)
    booking = Booking.find_by(checkout_session_id: event.data.object.id)
    booking.update(status: "approved")
    StartBookingJob.set(wait_until: booking.start_date).perform_later
    FinishBookingJob.set(wait_until: booking.end_date).perform_later
  end
end