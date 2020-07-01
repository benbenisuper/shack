class ReviewsController < ApplicationController
	before_action :authenticate_user!
	skip_before_action :authenticate_user!, only: [:index, :show]

	def new
		@review = Review.new
		authorize @review
	end

	def create
    @booking = Booking.find(params[:review][:booking_id].to_i)
		@review = Review.new(review_params)
		authorize @review
    @review.booking = @booking
		@review.user = current_user
    if @booking.user = current_user
      @review.reviewable = @booking
    else
      @review.reviewable = @booking.user
    end

		if @review.save
		  redirect_to booking_path(@booking)
    end

	end

  # def edit
  #   @review = Review.find(params[:id])
  #   authorize @review
  #   @status_message = @review.status.to_i == 1 ? 'Payment Pending' : 'Confirmed'
  # end

  # def update
  #   @review = Review.find(params[:id])
  #   authorize @review
  #   if @review.update(review_params)
  #     redirect_to booking_path(@review)
  #   else
  #     render :edit
  #   end
  # end

  # def destroy
  #   @review = Review.find(params[:id])
  #   authorize @review
  #   @review.destroy
  #   redirect_to dashboard_path
  # end

  private

  def review_params
  	params.require(:review).permit(:title, :rating, :comment, :booking, :reviewable_type, :reviewable_id)
  end
end
