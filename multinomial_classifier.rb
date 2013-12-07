require 'csv'

class MultinomialClassifier
	attr_accessor :distribution
	
	# Creates a distribution hash from a csv 
	# Expects a csv of the type created by build_multinomial.rb
	# which includes a header row
	def self.load_from_csv path_to_csv
		distribution = {}
		CSV.parse(open(path_to_csv).read).each_with_index do |row, row_num|
			if row_num > 0 # skip header row
				rating = row[0].to_i
				proportion = row[1].to_f
				distribution[rating] = proportion
			end
		end

		self.new distribution
	end

	def initialize distribution
		@distribution = distribution
	end

	# For a pair of ratings, calculate
	# the probabilty of the two ratings occurring in
	# sequence as the product of their individual probabilities.
	def probability_of_pair r1, r2
		distribution[r1] * distribution[r2]
	end
end