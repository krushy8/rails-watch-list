require 'open-uri'
require 'json'

puts "Cleaning the DB...."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all


puts "Creating movies.... \n"

(1..5).each do |num|
  url = "http://tmdb.lewagon.com/movie/top_rated?page=#{num}"
  response = JSON.parse(URI.open(url).read)

  response['results'].each do |movie_hash|
    puts "...creating #{movie_hash['title']}..."

    Movie.create!(
      poster_url: "https://image.tmdb.org/t/p/w500#{movie_hash['poster_path']}",
      rating: movie_hash['vote_average'],
      title: movie_hash['title'],
      overview: movie_hash['overview']
    )
  end
end

puts "... created #{Movie.count} movies."


puts "Creating lists..."

good_movies = List.create!(name: "Good Movies")
bad_movies  = List.create!(name: "Bad Movies")


good_movies.photo.attach(
  io: File.open(Rails.root.join("app/assets/images/good_movies.jpeg")),
  filename: "good_movies.jpeg",
  content_type: "image/jpeg"
)

bad_movies.photo.attach(
  io: File.open(Rails.root.join("app/assets/images/bad_movies.jpg")),
  filename: "bad_movies.jpg",
  content_type: "image/jpeg"
)


puts "Adding movies to lists..."

movies = Movie.all.sample(50)

good_comments = [
  "My favorite movie",
  "Masterpiece",
  "Must watch!",
  "Incredible performance",
  "Absolutely loved it"
]

bad_comments = [
  "Waste of my life",
  "Wouldn't recommend",
  "Boring af",
  "Pretty disappointing",
  "Waste of time"
]

movies.each do |movie|
  if movie.rating >= 8
    Bookmark.create!(
      comment: good_comments.sample,
      movie: movie,
      list: good_movies
    )
  else
    Bookmark.create!(
      comment: bad_comments.sample,
      movie: movie,
      list: bad_movies
    )
  end
end

puts "Finished!"
puts "Good Movies count: #{good_movies.bookmarks.count}"
puts "Bad Movies count: #{bad_movies.bookmarks.count}"
