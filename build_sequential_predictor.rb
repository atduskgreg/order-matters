require 'csv'

if ARGV.length < 1
	puts "Usage: ruby build_sequential_predictor.rb path/to/training/conditional_probability.csv <optional/output.csv>"
	
	exit
end

path_to_conditional = ARGV[0]
path_to_output = ARGV[1]

cond_prob = {}
(1..5).each do |prior|
	cond_prob[prior] = {}
	(1..5).each do |posterior|
		cond_prob[prior][posterior] = 0
	end
end

# load conditional which is really in the form of a multinomial per pair
rows = CSV.parse(open(path_to_conditional).read)
rows.each_with_index do |row, i|
	if i > 0 # skip header row
		cond_prob[row[0].to_i][row[1].to_i] = row[2].to_f
	end
end

# calculate conditional probability per prior from overall multinomial
cond_prob.collect do |prior, posts|
	total_per_prior = posts.values.inject{|sum, x| sum + x}

	posts.each do |post,prob|
		cond_prob[prior][post] = prob / total_per_prior
	end
end

mse = {}
cond_prob.each do |prior, posts|
	mse[prior] = {}
	posts.each do |rating, probability|
		mse[prior][rating] = 0
		[1,2,3,4,5].each do |i|
			mse[prior][rating] = mse[prior][rating] + posts[i] * ((rating-i)**2)

		end
	end
end

puts mse.inspect

mse.each do |prior,dist|
	# puts "#{prior.class}, #{dist.class}"
	if dist.is_a? Hash
		dist.each do |k,v|
			mse[prior][k] = v / 5.0
		end
	end
end

mse.each do |prior,dist|
	puts
		# puts "#{prior.class}, #{dist.class}"

	if dist.is_a? Hash
		dist.sort_by{|k,v| v }.each do |k,v|
			puts "Prediction for #{prior}: #{k}\tMSE: #{v}"
		end
	end
end


if path_to_output
	# do output stuff
	CSV.open(path_to_output, "wb") do |csv|
		csv << ["prior", "posterior", "mse"]
		mse.each do |prior,dist|
			if dist.is_a? Hash
				dist.each do |k,v|
					csv << [prior, k, v]
				end
			end
		end
	end
	puts "Saved #{path_to_output}"
end