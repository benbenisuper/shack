class Api::V1::DaysController < ApplicationController
  def show
  	@hours = []
  	@day = Day.find(params[:id])
  	authorize @day
  	24.times do |hr|
  		@hours << { hour: hr, available: @day.available_for_hour(hr) }
  	end
  end
end
