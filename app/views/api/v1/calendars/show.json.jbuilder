json.calendar @calendar
if @days.class == Array
	json.days @days
else
	json.days @days.order(:date)
end

json.day_colors @day_colors
json.date_limits @date_limits