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

# sort user ratings in ascending order by timestamp
user_scores.each do |user, ratings|
	user_scores[user] = ratings.sort do |a,b| 
		if a[:timestamp] > b[:timestamp]
			1
		elsif a[:timestamp] < b[:timestamp]
			-1
		else
			0
		end
	end
end

