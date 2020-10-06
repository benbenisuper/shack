class VenuesController < ApplicationController
	
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index, :show]

  def new
    @venue = Venue.new
    @venue_spec = VenueSpec.new(venue: @venue)
    @venue.build_venue_spec

    authorize @venue
  end

  def create
    @venue = Venue.new(venue_params)
    if params.require(:venue)[:perks].nil?
      @venue.perks = []
    else
      @venue.perks = params.require(:venue)[:perks][0..-1].join(', ')
    end
    authorize @venue

    @venue.build_venue_spec(venue_spec_params)

    @user = current_user
    @venue.user = @user
    @venue.sku = @venue.name
    

    if @venue.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def index
    @location = params["location"]
    @location = "City" if @location == "" || @location == nil
    @category = params["/venues"].nil? ? "All Categories" : params["/venues"]["category"]
    @activity = params["/venues"].nil? ? "All Activities" : params["/venues"]["activity"]
    @filter = { location: @location, category: @category, activity: @activity }.to_json
    # if (@location == "City") && (@category == nil || @category == "All Categories") && (@activity == nil || @activity == "All Activities")
    #   @venues = policy_scope(Venue).order(created_at: :desc)
    # else
    #   if @location == "City"
    #     @venues = policy_scope(Venue).order(created_at: :desc).where(category: @category, activity: @activity)
    #   else
    #     @venues = policy_scope(Venue).order(created_at: :desc).where(category: @category, activity: @activity)

    #     @venues = @venues.where(["location like ?", "%#{@location}%"])
    #   end
    # end
    @venues = policy_scope(Venue).where(published: true)
    @venues_geocoded = @venues.geocoded #returns flats with coordinates

    @markers = @venues_geocoded.map do |venue|
      {
        lat: venue.latitude,
        lng: venue.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { venue: venue })
      }
    end
  end

  def show

    @venue = Venue.find(params[:id])
    @booking = @venue.bookings.build
    @perks = @venue.perks.split(", ")
    authorize @venue

    @weekdays = Calendar::WEEKDAYS.map{|wday| t("dates.week.#{wday}")}
    @weekdays_full = Calendar::WDAYFULL.map{|wday| t("dates.week.full.#{wday}")}
    @months = Calendar::MONTHS.map{|month| t("dates.months.#{month}")}
    init_month = Date.today.month
    init_year = Date.today.year
    @calendar = @venue.calendar
    @calendar_days = @calendar.calendar_days_for_month(init_year, init_month)
    @day_colors = @calendar.days_of_this_month(init_year, init_month)

    @bookings = Booking.where(venue_id: @venue.id.to_i)
    @reviews = []
    @bookings.each do |booking|
      @reviews << Review.find_by(booking_id: booking.id.to_i)
    end
    @markers = [
      {
        lat: @venue.latitude,
        lng: @venue.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { venue: @booking.venue })
      }
    ]
  end

  def destroy
    @venue = Venue.find(params[:id])

    authorize @venue

    @venue.destroy
    redirect_to dashboard_path
  end

  def edit
    @venue = Venue.find(params[:id])

    authorize @venue
  end

  def update
    @venue = Venue.find(params[:id])
    authorize @venue
    if params[:day].present?
      calendar = Calendar.find(params[:day][:calendar])
      option = JSON.parse(params[:day][:option])
      day_price = params[:day][:day_price]
      hour_price = params[:day][:hour_price]
      month = params[:day][:month]
      year = params[:day][:year]
      type = option["type"]
      value = option["value"]
      case type
      when "day"
        unless day_price == ""
          calendar.update_day_price_for_date(value, day_price.to_i)
        end
        unless hour_price == ""
          calendar.update_hour_price_for_date(value, hour_price.to_i)
        end
      when "weekday"
        unless day_price == ""
          calendar.update_day_price_for_wday_of_month(month, value, day_price.to_i)
        end
        unless hour_price == ""
          calendar.update_hour_price_for_wday_of_month(month, value, hour_price.to_i)
        end
      when "weeknum"
        unless day_price == ""
          calendar.update_day_price_for_wnum_of_year(year, value, day_price.to_i)
        end
        unless hour_price == ""
          calendar.update_hour_price_for_wnum_of_year(year, value, hour_price.to_i)
        end
      when "month"
        unless day_price == ""
          calendar.update_day_price_for_month(value, day_price.to_i)
        end
        unless hour_price == ""
          calendar.update_hour_price_for_month(value, hour_price.to_i)
        end
      end
    else
      @venue.perks = params.require(:venue)[:perks][1..-1].join(', ')
      @venue.venue_spec.update(venue_spec_params)
    end

    respond_to do |format|
      if params[:day].present?
        format.html { redirect_to venue_path(@venue) }
      else
        if @venue.update(venue_params)
          format.html { redirect_to venue_path(@venue) }
        else
          format.html { redirect_to :new }
        end
      end
    end

  end

  private

  def venue_params
    params.require(:venue).permit(:name, :location, :category, :description, :capacity, :perks, :price, :activity, photos: [], 
          venue_spec_attributes: [:spaces, :garage_spaces, :bathrooms, :total_area])
  end

  def venue_spec_params
    params.require(:venue).require(:venue_spec_attributes).permit(:spaces, :garage_spaces, :bathrooms, :total_area)
  end

end
