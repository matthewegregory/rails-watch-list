# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "open-uri"
require "json"

puts "cleaning the db"
Movie.destroy_all

top_rated_movies_url = 'https://tmdb.lewagon.com/movie/top_rated'

serialized_response = URI.parse(top_rated_movies_url).read

response = JSON.parse(serialized_response)

movies = response['results']

movies.each do |movie|
  puts "adding #{movie['title']}"
  Movie.create!(
    title: movie['title'],
    overview: movie['overview'],
    rating: movie['vote_average'].round(1),
    poster_url: movie["http://image.tmdb.org/t/p/original#{movie['poster_path']}"]
  )
end
