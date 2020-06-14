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
puts("Destroying all Bookings")
Booking.delete_all
puts("Destroying all Reviews")
Venue.delete_all
puts("Destroying all Users")
User.delete_all
puts("Destroying all Admin Users")
AdminUser.delete_all


morgan = User.create!(email: "morgan@shack.com", password: "testtest", first_name: "Morgan", last_name: "X", phone:"0000", role: :host)
ben = User.create!(email: "ben@shack.com", password: "testtest", first_name: "Ben", last_name: "X", phone:"0000", role: :host)
admin = User.create!(email: "admin@shack.com", password: "password", first_name: "admin", last_name: "user", phone:"999", role: :admin)

AdminUser.create!(email: 'admin@shack.com', password: 'password', password_confirmation: 'password')


puts("Creating Venues")

venue_1 = Venue.create!(name: "Whateva",
 location: "Pedro Palacios 582, Neuquén, Neuquén, Argentina",
 user: morgan,
 category: "Outdoor",
 description: "Dinner with la flia",
 capacity: 6,
 activity: "Wedding",
 price: 5666,
 perks: "Internet, Parking, Air Conditioning, Heating, Security, Kitchen, Catering, Handycap Friendly")

venue_2 = Venue.create!(name: "Dinner with Ben",
 location: "Lausanne, Vaud, Switzerland",
 user: ben,
 category: "Castle",
 description: "Dinner plans",
 capacity: 10,
 activity: "Dinner",
 price: 500,
 perks: "Internet, Parking, Air Conditioning, Security, Kitchen, Catering, Handycap Friendly")


puts("Creating Bookings")

booking_1 = Booking.create!(user: ben,
  start_date: DateTime.parse("Tue, 16 Jun 2020 00:00:00 UTC +00:00"),
  end_date: DateTime.parse("Wed, 17 Jun 2020 00:00:00 UTC +00:00"),
  venue: venue_1)
booking_1.price = booking_1.venue.price * ((booking_1.end_date.day() - booking_1.start_date.day()).to_i + 1)
booking_1.save