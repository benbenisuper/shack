# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require 'faker'


puts("Destroying all Reviews")
Review.delete_all
puts("Destroying all ChatBoxes")
ChatBox.delete_all
puts("Destroying all Bookings")
Booking.delete_all
puts("Destroying all Days")
Day.delete_all
puts("Destroying all Calendars")
Calendar.delete_all
puts("Destroying all Venue Specs")
VenueSpec.delete_all
puts("Destroying all Venues")
Venue.delete_all
puts("Destroying all Users")
User.delete_all
puts("Destroying all Admin Users")
AdminUser.delete_all


morgan = User.create!(email: "morgan@keyspot.com", password: "testtest", first_name: "Morgan", last_name: "X", phone:"0000", role: :host)
ben = User.create!(email: "ben@keyspot.com", password: "testtest", first_name: "Ben", last_name: "X", phone:"0000", role: :host)
admin = User.create!(email: "admin@keyspot.com", password: "password", first_name: "admin", last_name: "user", phone:"999", role: :admin)

AdminUser.create!(email: 'admin@keyspot.com', password: 'password', password_confirmation: 'password')


puts("Creating Venues")

venue_1 = Venue.create!(name: "Whateva",
 sku: "Whateva",	
 location: "Pedro Palacios 582, Neuquén, Neuquén, Argentina",
 user: morgan,
 category: "Outdoor",
 description: "Dinner with la flia",
 capacity: 6,
 activity: "Wedding",
 price: 30,
 perks: "Internet, Parking, Air Conditioning, Heating, Security, Kitchen, Catering, Handicap Friendly")
venue_1_spec = VenueSpec.create!(venue: venue_1, spaces: 4, garage_spaces: 4, bathrooms: 4, total_area: 4)

venue_2 = Venue.create!(name: "Dinner with Ben",
 sku: "Dinner with Ben",
 location: "Lausanne, Vaud, Switzerland",
 user: ben,
 category: "Castle",
 description: "Dinner plans",
 capacity: 10,
 activity: "Dinner",
 price: 50,
 perks: "Internet, Parking, Air Conditioning, Security, Kitchen, Catering, Handicap Friendly")
venue_2_spec = VenueSpec.create!(venue: venue_2, spaces: 4, garage_spaces: 4, bathrooms: 4, total_area: 4)


puts("Creating Bookings")

booking_1 = Booking.create!(user: ben,
  start_date: DateTime.parse("Tue, 16 Jun 2020 00:00:00 UTC +00:00"),
  end_date: DateTime.parse("Wed, 17 Jun 2020 00:00:00 UTC +00:00"),
  venue: venue_1)
booking_1.amount = booking_1.venue.price * ((booking_1.end_date.day() - booking_1.start_date.day()).to_i + 1)
booking_1.save


## ADD SPEC MODEL TO ALL VENUES!

# Venue.all.each do |venue|
# 	spec = VenueSpec.create!(venue: venue) unless venue.venue_spec
# end

# Venue.all.each do |venue|
# 	venue.photos.attach(io: URI.open("https://res.cloudinary.com/mhoare/image/upload/v1582654608/defaultEventImage.jpg"),
# 	filename: "defaultEventImage.jpg",
# 	content_type: "image/jpg") if venue.photos.count.zero?
# end

# CEATE CALENDARS FOR VENUES

# Venue.all.select{|venue| venue.calendar == nil }.each do |venue|
# 	Calendar.create!(
# 		venue: venue, 
#       hour_price_cents: venue.price_cents / 24, 
#       day_price_cents: venue.price_cents, 
#       min_time: "00:00",
#       max_time: "23:59",
#       day_discount: "0.2")
# end

# Venue.all.each do |venue|
# 	timezone = Timezone.lookup(venue.latitude, venue.longitude)
# 	venue.update(zone: timezone.name)
# 	end