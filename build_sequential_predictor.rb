require 'csv'

if ARGV.length < 2
	puts "Usage: ruby build_sequential_predictor.rb path/to/training.data.csv path/to/training/multinomial.csv <optional/output.csv>"
	puts "* Expects training data as csv with columns: user id,item id,rating,previous rating,time delta."
	puts "* Expects multinomial as csv with columns: rating,proportion."
	exit
end

path_to_data = ARGV[0]
path_to_multinomial = ARGV[1]
path_to_output = ARGV[2]

multinomial = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0}


rows = CSV.parse(open(path_to_multinomial).read)
rows.each_with_index do |row, i|
	if i > 0 # skip header row
		multinomial[row[0].to_i] = row[1].to_f
	end
end

means = {1 => [], 2 => [], 3 => [], 4 => [], 5 => []}

all_ratings = []


first = true
CSV.foreach( path_to_data ) do |row|
	if first
		first = false
		next
	end

	user_id = row[0]
	item_id = row[1]
	rating = row[2].to_i
	previous_rating = row[3].to_i
	time_delta = row[4].to_i

	means[previous_rating] << (rating  + (previous_rating * (200-time_delta)/200.0))/2.0
	all_ratings << rating
end

means.each do |k,v|
	means[k] = (means[k].inject{|sum, i| sum+i} / means[k].length.to_f).round
end

puts means.inspect


if path_to_output
	# do output stuff
end