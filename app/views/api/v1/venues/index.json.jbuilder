# json.array! @venues do |venue|
#  	json.extract! venue, :id, :name, :location, :user, :category, :description, :capacity, :activity, :price, :latitude, :longitude, :perks, :average_rating, :venue_image
# end

json.venues @venues do |venue|
	json.extract! venue, :id, :name, :location, :user, :category, :description, :capacity, :activity, :price, :latitude, :longitude, :perks, :average_rating, :venue_image, :reviews
end

json.filter @filter
