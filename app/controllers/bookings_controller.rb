class BookingsController < ApplicationController
	before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index, :show]

  def new
    @booking = Booking.new
    authorize @booking
  end

  def create
    venue = Venue.find(params[:booking][:venue_id])
    start_date = ActiveSupport::TimeZone[venue.zone].parse(params[:booking][:start_date])
    end_date = ActiveSupport::TimeZone[venue.zone].parse(params[:booking][:end_date])
    amount = params[:booking][:amount].to_f
    hours = (end_date - start_date) / 3600
    booking  = Booking.create!(venue: venue, amount: amount, start_date: start_date, end_date: end_date, venue_sku: venue.sku, status: 'pending', user: current_user)
    authorize booking
    session = Stripe::Checkout::Session.create({
      mode: 'payment',
      payment_method_types: ['card'],
      line_items: [{
        name: venue.sku,
        images: venue.photos.map{ |photo| photo.service_url },
        amount: booking.amount_cents,
        currency: 'chf',
        quantity: 1,
      }],
      payment_intent_data: {
        application_fee_amount: (booking.amount_cents * 0.08).to_i,
        transfer_data: {
          destination: "#{venue.user.uid}",
        },
      },
      success_url: booking_url(booking),
      cancel_url: booking_url(booking),
    })

    booking.update(checkout_session_id: session.id)
    redirect_to new_booking_payment_path(booking)
  end

  def show
    @booking = Booking.find(params[:id])
    @perks = @booking.venue.perks.split(", ")
    authorize @booking
    @chat_box = @booking.chat_box
    session[:previous_request_url] = session[:current_request_url]
    if current_user == @booking.user
      if @booking.is_commented?
        @review = Review.find_by(booking_id: @booking.id.to_i, reviewable_type: "Booking")
      end
    else
      if @booking.user_is_commented?
        @review = Review.find_by(booking_id: @booking.id.to_i, reviewable_type: "User")
      end
    end
    @status_message = @booking.status.to_i == 1 ? 'Payment Pending' : 'Confirmed'
    @markers = [
      {
        lat: @booking.venue.latitude,
        lng: @booking.venue.longitude
      }
    ]
  end

  def edit
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.amount = @booking.venue.price * ((@booking.end_date - @booking.start_date).to_i + 1)
    @status_message = @booking.status.to_i == 1 ? 'Payment Pending' : 'Confirmed'

  end

  def update
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.status = 2
    if @booking.update(booking_params)
      session.delete(:return_to)
      redirect_to booking_path(@booking)
    else
      render :edit
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.destroy
    if session[:return_to].nil?
      redirect_to dashboard_path
    else
      redirect_to venue_path(@booking.venue)
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:user, :start_date, :end_date, :venue_id)
  end

end
