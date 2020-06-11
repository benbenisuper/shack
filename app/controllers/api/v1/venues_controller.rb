class Api::V1::VenuesController < Api::V1::BaseController
  before_action :set_venue, only: [ :show ]

  def index
    @category = params[:category]
    @activity = params[:activity]
    @bounds = {
      ne_lat: params[:ne_lat].to_f,
      sw_lat: params[:sw_lat].to_f,
      ne_lng: params[:ne_lng].to_f,
      sw_lng: params[:sw_lng].to_f
    }
    @filter = {
      category: params[:category],
      activity: params[:activity],
      bounds: @bounds
    }
    if @category.nil? && @activity.nil?
      @venues = policy_scope(Venue)
    else
      @venues = policy_scope(Venue).select do |venue| 
        venue.is_in_mapbox(@bounds) && (venue.category == @category || @category == "All Categories") && (venue.activity == @activity || @activity == "All Activities")
      end
    end
    # @venues = policy_scope(Venue)
  end

  def show
  end

  private

  def set_venue
    @venue = Venue.find(params[:id])
    authorize @venue  # For Pundit
  end
end