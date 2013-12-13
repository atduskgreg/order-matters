if ARGV.length < 3
	puts "Usage: ruby build_test_train.rb path/to/user/sequences.csv train_percentage max_delta <train.data> <test.data>"
	puts "* Expects user sequence data as a csv in the form:"
	puts "\t  user_id,previous rating,rating,rating delta,prev rating time,rating time,time delta,previous movie id,movie id,movie average"
	puts "\tas in the form produced by build_sequence_data.rb"
	puts "* Selects ratings that are part of time gaps t, such that: 0 < t < max_delta (in seconds)"
	puts "* Randomly partitions these ratings into test and train sets, which are saved as both\n\ttab-delimited data in the original MovieLens format and as csv files with the additional ordering information."
	exit
end

require 'csv'

path_to_data = ARGV[0]
train_percentage = ARGV[1].to_i / 100.0
max_time_delta = ARGV[2].to_i
path_to_train = ARGV[3] || "train.data"
path_to_test = ARGV[4] || "test.data"

path_to_train_csv = "#{path_to_train}.csv"
path_to_test_csv = "#{path_to_test}.csv"

File.open(path_to_train, "wb") do |train_file|
 	File.open(path_to_test, "wb") do |test_file|
 		CSV.open(path_to_train_csv, "wb") do |train_csv|
 			CSV.open(path_to_test_csv, "wb") do |test_csv|
 				header = ["user id", "item id", "rating", "previous rating", "time delta"]
 				train_csv << header
 				test_csv << header

 				first_row = true;

				CSV.foreach(path_to_data) do |row|
					if first_row
						first_row = false
						next
					else
						user_id = row[0]
						previous_rating = row[1].to_i
						rating = row[2].to_i
						timestamp = row[5]
						time_delta = row[6].to_i
						item_id = row[8]

						if time_delta > 0 && time_delta < max_time_delta
							# user id | item id | rating | timestamp
							movielens_format = "#{user_id}\t#{item_id}\t#{rating}\t#{timestamp}\n"
							csv_row = [user_id, item_id, rating, previous_rating, time_delta]
							if rand < train_percentage
 								train_file << movielens_format
 								train_csv << csv_row
 							else
 								test_file << movielens_format
 								test_csv << csv_row
 							end
						end
					end
				end
			end
		end
	end
end