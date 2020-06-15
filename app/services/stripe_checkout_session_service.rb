class StripeCheckoutSessionService
  def call(event)
    @booking = Booking.find_by(checkout_session_id: event.data.object.id)
    authorize @booking
    @booking.update(status: "approved")
  end
end