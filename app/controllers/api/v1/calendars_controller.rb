class Api::V1::CalendarsController < Api::V1::BaseController
  before_action :get_calendar
  # skip_before_action :authenticate_user!, only: [:show]

  def show
  	if params[:year].present? && params[:month].present?
  		year = params[:year].to_i
      month = params[:month].to_i
      first_date = @calendar.days.first.date + 1.month
      last_date = @calendar.days.last.date - 1.month
      @date_limits = { first: "#{first_date.month}/#{first_date.year}", last: "#{last_date.month}/#{last_date.year}" }
      @days = @calendar.calendar_days_for_month(year, month)
      @day_colors = @calendar.days_of_this_month(year, month)
    else
      @days = @calendar.days
    end
  end

	def update
		if params[:disable].present?
			day = Day.find(params[:disable])
			day.update(disabled: true)
		end
	end

  private

  def get_calendar
    @calendar = Calendar.find(params[:id])
    authorize @calendar
  end
end
