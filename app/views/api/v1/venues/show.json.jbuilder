json.extract! @venue, :id, :name, :location, :user, :category, :description, :capacity, :activity, :price, :latitude, :longitude, :perks
json.bookings @venue.bookings do |booking|
	json.extract! booking, :id, :user, :start_date, :end_date, :status, :price 
end
