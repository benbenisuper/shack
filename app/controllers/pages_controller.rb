class PagesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
    @bookings = current_user.bookings
    @venues = current_user.venues
    @next_checkin = current_user.next_checkin
    @next_checkout = current_user.next_checkout
  end
end
