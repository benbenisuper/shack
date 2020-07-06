# json.array! @venues do |venue|
#  	json.extract! venue, :id, :name, :location, :user, :category, :description, :capacity, :activity, :price, :latitude, :longitude, :perks, :average_rating, :venue_image
# end
json.venues @venues do |venue|
	json.extract! venue, :id, :name, :location, :user, :category, :description, :capacity, :activity, :price_cents, :latitude, :longitude, :perks, :average_rating, :reviews
	
	venue_images = []
	venue.photos.each do |photo|
		venue_images << rails_blob_url(photo)
	end
	json.venue_images venue_images
end

json.filter @filter
