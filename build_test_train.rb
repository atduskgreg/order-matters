require 'csv'

if ARGV.length < 1
	puts "Usage: ruby build_test_train.rb path/to/movie/lens.data train_percentage <train_filename.csv> <test_filename.csv>"
	puts "Randomly partitions MovieLens ratings data into test and train sets, which are saved as CSVs."
	exit
end

path_to_data = ARGV[0]
train_percentage = ARGV[1].to_i / 100.0
path_to_train = ARGV[2] || "train.csv"
path_to_test = ARGV[3] || "test.csv"

CSV.open(path_to_train, "wb") do |train_csv|
	CSV.open(path_to_test, "wb") do |test_csv|

		train_csv << ["user_id", "item_id", "rating", "timestamp"]
		test_csv  << ["user_id", "item_id", "rating", "timestamp"]
	
		lines = open(path_to_data).read.split(/\n/)
		lines.each do |line|
		# split and parse tab-delimited data format based on information in Movie Lens's README
			parts = line.split(/\t/)
			user_id = parts[0]
			item_id = parts[1]
			rating = parts[2].to_i
			timestamp = parts[3].to_i

			row = [user_id, item_id, rating, timestamp]
		
			if rand < train_percentage
				train_csv << row
			else
				test_csv << row
			end
			
		end
	end
end