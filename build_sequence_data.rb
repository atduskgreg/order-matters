# This script parses the MovieLens 100k data and builds a csv
# that's organized around a series of sequential pairs of ratings
# produced by each user.
require 'csv'

DATA_FOLDER = "../ml-100k"

# find average score for each movie
# look to see if users' scores are affected by their scoring of the previous movie

item_scores = {}
user_scores = {}

open(DATA_FOLDER + "/u.data").read.split(/\n/).each do |line|
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

	# build per-user score collection for order-based analysis
	if !user_scores[user_id]
		user_scores[user_id] = [{:item_id => item_id, :rating => rating, :timestamp => timestamp}]
	else
		user_scores[user_id] << {:item_id => item_id, :rating => rating, :timestamp => timestamp}
	end
end

# find average scores for each item
item_scores.each do |item_id, ratings|
	item_scores[item_id] = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
end

# for each user-rating collect:
# rating n-1
# rating n
# difference between n and n-1
# average for movie at n

i = 1

CSV.open("100k_user_sequences.csv", "wb") do |csv|
	# column headers
    csv << ["user_id", "previous rating", "rating", "rating delta", "prev rating time", "rating time", "time delta", "previous movie id", "movie id", "movie average"]
	
	user_scores.each do |user, ratings|
		puts "#{i}/#{user_scores.length}"; i = i + 1
		 # populate user_id column

		# sort user ratings in ascending order by timestamp
		ratings.sort! do |a,b| 
			if a[:timestamp] > b[:timestamp]
				1
			elsif a[:timestamp] < b[:timestamp]
				-1
			else
				0
			end
		end

		ratings.each_with_index do |current, i|
			if i > 0
				row = [user]
				prev = ratings[i-1]
				prev_rating = prev[:rating]
				rating = current[:rating]
				rating_delta = rating - prev_rating
				prev_movie_id = prev[:item_id]
				movie_id = current[:item_id]
				movie_average = item_scores[movie_id]
				prev_rating_time = prev[:timestamp]
				rating_time = current[:timestamp]
				time_delta = rating_time - prev_rating_time

				row << prev_rating
				row << rating
				row << rating_delta
				row << prev_rating_time
				row << rating_time
				row << time_delta
				row << prev_movie_id
				row << movie_id
				row << movie_average
				csv << row
			end
		end



	end
end


