json.calendar @calendar
if @days.class == Array
	json.days @days do |day|
		json.extract! day, :id, :calendar_id, :month, :year, :wday, :hour_price_cents, :hour_price_currency, :day_price_cents, :day_price_currency, :min_time, :max_time, :date, :day, :wnum, :created_at, :updated_at, :has_booking
	end
else
	# json.days @days.order(:date)
	json.days @days.order(:date) do |day|
		json.extract! day, :id, :calendar_id, :month, :year, :wday, :hour_price_cents, :hour_price_currency, :day_price_cents, :day_price_currency, :min_time, :max_time, :date, :day, :wnum, :created_at, :updated_at, :has_booking
	end
end

json.day_colors @day_colors
json.date_limits @date_limits