if ARGV.length < 1
	puts "usage: ruby build_multinomial.rb path/to/movie/lens.data <optional/path/for/multinomial.csv>"
	puts "expects tab-delimited data in the form of:"
	puts "user_id item_id rating timestamp"
	exit
end

require 'csv'

path_to_movie_lens = ARGV[0]
path_to_output_csv = ARGV[1]

rating_counts = {}

lines = open(path_to_movie_lens).read.split(/\n/)
lines.each do |line|
	# split and parse tab-delimited data format based on information in Movie Lens's README
	parts = line.split(/\t/)
	user_id = parts[0]
	item_id = parts[1]
	rating = parts[2].to_i
	timestamp = parts[3].to_i


	if rating_counts[rating] 
		rating_counts[rating] = rating_counts[rating] + 1
	else
		rating_counts[rating] = 1 
	end	
end

total_ratings = rating_counts.values.inject{|a,b|  a + b}

puts "Total ratings counted: #{total_ratings}/#{lines.length}"
if lines.length != total_ratings
	puts "WARNING: Didn't capture one rating per-line. Something fishy with the format?"
end
puts "Proportion for each rating:"
rating_counts.keys.sort.each do |rating|
	puts "#{rating} star: #{rating_counts[rating].to_f/total_ratings}"
end

if path_to_output_csv
	CSV.open(path_to_output_csv, "wb") do |csv|
		csv << ["rating", "proportion"]
		rating_counts.keys.sort.each do |rating|
			csv << [rating, rating_counts[rating].to_f/total_ratings]
		end
	end

	puts "saved #{path_to_output_csv}"
end