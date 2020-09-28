class CalendarsController < ApplicationController
  def update
    @calendar = policy_scope(Calendar).find(params[:id])
    authorize @calendar
    disable_params = params[:calendar][:disable]

    action = params[:disable].present? ? false : true

    if disable_params[:to].present?
      start_date = disable_params[:from].to_date
      end_date = disable_params[:to].to_date
      @calendar.days.each do |day|
        if day.date > start_date && day.date <= end_date + 1.day
          day.update(disabled: action) unless day.bookings.count > 0
        end
      end
    elsif disable_params[:from].present?
      date = disable_params[:from].to_date
      day = @calendar.days.find_by(day: date.day, month: date.month, year: date.year)
      day.update(disabled: action) unless day.bookings.count > 0
		end
	end
end
