class BookingsController < ApplicationController
	before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index, :show]

  def new
    @booking = Booking.new
    authorize @booking
  end

  def create
    venue = Venue.find(params[:booking][:venue_id])
    start_date = params[:booking][:start_date]
    end_date = params[:booking][:end_date]
    amount = venue.price * ((end_date.to_date - start_date.to_date).to_i + 1)
    booking  = Booking.create!(venue: venue, amount: amount, start_date: start_date, end_date: end_date, venue_sku: venue.sku, status: 'pending', user: current_user)
    authorize booking
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: venue.sku,
        images: venue.photos.map{ |photo| photo.service_url },
        amount: booking.amount_cents,
        currency: 'chf',
        quantity: 1
      }],
      success_url: booking_url(booking),
      cancel_url: booking_url(booking)
      )

    booking.update(checkout_session_id: session.id)
    redirect_to new_booking_payment_path(booking)




    # @booking = Booking.new(booking_params)
    # authorize @booking
    # @booking.status = "pending"
    # @user = current_user
    # @booking.user = @user
    # if @booking.amount.nil?
    # @booking.amount = @booking.venue.price * ((@booking.end_date - @booking.start_date).to_i + 1)
    # end
    # if @booking.save
    #   session = Stripe::Checkout::Session.create(
    #     payment_method_types: ['card'],
    #     line_items: [{
    #       name: @venue.sku,
    #       amount: @venue.price_cents,
    #       currency: 'chf',
    #       quantity: 1
    #     }],
    #     success_url: booking_url(booking),
    #     cancel_url: booking_url(booking)
    #     )
    #   @booking.update(checkout_session_id: session.id)
    #   session[:return_to] ||= request.referer
    #   redirect_to edit_booking_path(@booking)
    # else
    #   render :new
    # end
  end

  def show
    @booking = Booking.find(params[:id])
    @perks = @booking.venue.perks.split(", ")
    authorize @booking
    @booking.amount = @booking.venue.price * ((@booking.end_date.day() - @booking.start_date.day()).to_i + 1)
    if @booking.is_commented?
      @review = Review.find_by(booking_id: @booking.id.to_i)
    else
      @review = Review.new
    end
    # @reviews = Review.where(booking_id: @booking.id.to_i)
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
      redirect_to session.delete(:return_to)
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:user, :start_date, :end_date, :venue_id)
  end

end
