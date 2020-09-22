class PagesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
    @bookings = current_user.bookings
    @venues = current_user.venues.select{ |v| v.upcoming_checkin_date[:date] }
    @next_checkin = current_user.next_checkin
    @next_checkout = current_user.next_checkout
    @latest_message_booking = "#"
    @latest_message_booking = booking_path(current_user.all_messages.first.chat_box.booking) unless current_user.all_messages.empty?
  end

end
