require 'csv'

if ARGV.length < 1
	puts "Usage: ruby build_test_train.rb path/to/movie/lens.data train_percentage <train_filename.data> <test_filename.data>"
	puts "Randomly partitions MovieLens ratings data into test and train sets, which are saved as tab-delimited data in the original MovieLens format."
	exit
end

path_to_data = ARGV[0]
train_percentage = ARGV[1].to_i / 100.0
path_to_train = ARGV[2] || "train.data"
path_to_test = ARGV[3] || "test.data"


File.open(path_to_train, "wb") do |train_file|
	File.open(path_to_test, "wb") do |test_file|

		lines = open(path_to_data).read.split(/\n/)
		lines.each do |line|
		# split and parse tab-delimited data format based on information in Movie Lens's README
			parts = line.split(/\t/)
			user_id = parts[0]
			item_id = parts[1]
			rating = parts[2].to_i
			timestamp = parts[3].to_i

			if rand < train_percentage
				train_file << "#{line}\n"
			else
				test_file << "#{line}\n"
			end
			
		end
	end
end