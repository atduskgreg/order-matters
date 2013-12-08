if ARGV.length < 1
	puts "Usage: ruby build_actual_pair_distribution.rb path/to/user_sequences.csv <optional/output/path/for/pair_distribution.csv>"
	puts "Expects a csv with a header row of:"
	puts "\tuser_id,previous rating,rating,rating delta,prev rating time,rating time,time delta,previous movie id,movie id,movie average"
	puts "and one row for each sequential pair of ratings from the same user."
	puts "See build_sequence_data.rb for more."
	exit
end

MAX_TIME_DELTA = 200


require 'csv'

path_to_csv = ARGV[0]
path_to_output_csv = ARGV[1]

pair_data = {}
(1..5).each do |i| 
	(1..5).each do |j| 
		pair_data["#{i},#{j}"] = 0
	end
end

num_rows = 0

# count occurrences of sequences
CSV.foreach(path_to_csv) do |row|
	user_id = row[0]
	previous_rating = row[1].to_i
	rating = row[2].to_i
	time_delta = row[6].to_i

	if time_delta > 0 && time_delta < MAX_TIME_DELTA
		pair_data["#{previous_rating},#{rating}"] = pair_data["#{previous_rating},#{rating}"] + 1
		num_rows = num_rows + 1
	end
end

total_pairs = pair_data.values.inject{|sum,x| sum+x}

puts "Total pairs counted: #{total_pairs}/#{num_rows}"
if num_rows != total_pairs
	puts "WARNING: Didn't capture one pair per-line. Something fishy with the format?"
end

# HERE: turn these counts into proportions
pair_data.each do |pair, count|
	pair_data[pair] = count/total_pairs.to_f
end


pair_data.each do |pair, probability|
	puts "#{pair}: #{probability}"
end

if path_to_output_csv
	CSV.open(path_to_output_csv, "wb") do |csv|
		csv << ["rating1", "rating2", "probability"]
		pair_data.each do |pair, probability|
			csv << [pair.split(","), probability].flatten
		end
	end
	puts "Saved #{path_to_output_csv}"
end


