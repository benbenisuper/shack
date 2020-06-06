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