if ARGV.length < 1
	puts "Usage: ruby build_pair_probability.rb path/to/multinomial.csv <optional/output/path/for/pair_probabilities.csv>"
	puts "Expects a csv with a header row of:"
	puts "\trating,proportion"
	puts "and one row for each rating option."
	puts "See build_multinomial.rb for an example."
	exit
end

path_to_multinomial_csv = ARGV[0]
path_to_output_csv = ARGV[1]

require './multinomial_pair_probability'

mpp = MultinomialPairProbability.load_from_csv( path_to_multinomial_csv )

mpp.pair_probability_distribution.each do |pair, probability|
	puts "#{pair}: #{probability}"
end

if path_to_output_csv
	CSV.open(path_to_output_csv, "wb") do |csv|
		csv << ["rating1", "rating2", "probability"]
		mpp.pair_probability_distribution.each do |pair, probability|
			csv << [pair.split(","), probability].flatten
		end
	end
	puts "Saved #{path_to_output_csv}"
end