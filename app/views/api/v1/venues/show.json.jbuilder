json.extract! @venue, :id, :name, :location, :user, :category, :description, :capacity, :activity, :price_cents, :latitude, :longitude, :perks, :average_rating, :reviews, :venue_spec
json.bookings @venue.bookings do |booking|
	json.extract! booking, :id, :user, :start_date, :end_date, :status, :price 
end

json.days @calendar.days do |day|
	json.extract! day, :day_price_cents
end

