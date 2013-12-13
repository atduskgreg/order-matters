require 'csv'

if ARGV.length < 1
	puts "Usage: ruby evaluate.rb path/to/test.data.csv <optional/output.csv>"
	exit
end

path_to_data = ARGV[0]

# prediction functions
def order_ignorant_predict( prev_rating )
	return 4
end

def order_aware_predict( prev_rating )
	h = {1=>-1.7965367965367964, 2=>-1.0640963855421686, 3=>-0.3262631315657829, 4=>0.3900370522848909, 5=>1.090803428737469}#h = {1=>-2, 2=>-1, 3=>0, 4=>0, 5=>1}
	(order_ignorant_predict(prev_rating) + 0.4 * h[prev_rating]).round
end


# load test data
# make predictions with each of these
# count mse or absolute error
oi_errors = []
oa_errors = []

better = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0}
num_different = 0

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
#	time_delta = row[4].to_i

	oi_predict = order_ignorant_predict( previous_rating )
	oa_predict = order_aware_predict( previous_rating )

	oi_error = rating - oi_predict
	oa_error = rating - oa_predict


	if oi_predict != oa_predict
		puts "rating: #{rating} OI: #{oi_predict} | OA: #{oa_predict}"

		num_different = num_different + 1

		if (rating - oi_predict).abs > (rating - oa_predict).abs 
			puts "BETTER"
			better[rating] = better[rating] + 1
		end
	end


	oi_errors << oi_error
	oa_errors << oa_error
end

puts better.inspect
puts "#{better.values.inject{|sum,i| sum+i}} / #{num_different}"

total_oi_error = oi_errors.inject{|sum,i| sum + i.abs}
total_oa_error = oa_errors.inject{|sum,i| sum + i.abs}

mse_oi_error = oi_errors.inject{|sum,i| sum + i**2}/oi_errors.length.to_f
mse_oa_error = oa_errors.inject{|sum,i| sum + i**2}/oa_errors.length.to_f


puts "Total Order-Ignorant Error: #{total_oi_error}"
puts "Total Order-Aware Error: #{total_oa_error}"

puts "MSE Error for Order-Ignorant: #{mse_oi_error}"
puts "MSE Error for Order-Aware: #{mse_oa_error}"
