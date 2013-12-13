require "#{File.expand_path(File.dirname(__FILE__))}/../models.rb"

if ARGV.length < 1
	puts "usage: ruby import_movies.rb path/to/movielens/ratings.data path/to/movielens/movie.data"
	exit
end

path_to_ratings_data = ARGV[0]
path_to_movie_data = ARGV[1]

item_scores = {}

open(path_to_ratings_data).read.split(/\n/).each do |line|
	# split and parse tab-delimited data format based on information in DATA_FOLDER/README
	parts = line.split(/\t/)
	user_id = parts[0]
	item_id = parts[1]
	rating = parts[2].to_i
	timestamp = parts[3].to_i

	# build per-item score dictionary for finding average scores
	if !item_scores[item_id]
		item_scores[item_id] = [rating]
	else
		item_scores[item_id] << rating
	end
end

# find average scores for each item
item_scores.each do |item_id, ratings|
	item_scores[item_id] = ratings.inject{ |sum, i| sum + i }.to_f / ratings.size
end

movies = {}
open(path_to_movie_data).read.force_encoding("iso-8859-1").split(/\n/).each do |line|
	#movie id | movie title | release date 
	parts = line.split(/\|/)
	movie_id = parts[0]
	movie_title = parts[1]
	release_date = parts[2] # format: 01-Jan-1994

	movies[movie_id] = {:title => movie_title, :release_date => release_date.split("-").last.to_i}
end

pre_count = Movie.count

item_scores.each do |movie_id, rating|
	if (rating > 2.75 && rating < 3.25)
		puts "Creating movie with rating of #{rating}."
		puts movies[movie_id].inspect

		begin

		Movie.create :title => movies[movie_id][:title].force_encoding("UTF-8"), 
					 :year => movies[movie_id][:release_date],
					 :movielens_rating => rating
		rescue DataObjects::DataError => e
			puts "ERROR: #{e.message}"
		end
	end
end

puts "Created #{Movie.count - pre_count} movies."