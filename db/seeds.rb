# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require 'faker'


puts("Destroying all Users")
User.delete_all

morgan = User.create!(email: "morgan@shack.com", password: "testtest", first_name: "Morgan", last_name: "X", phone:"0000")
ben = User.create!(email: "ben@shack.com", password: "testtest", first_name: "Ben", last_name: "X", phone:"0000")