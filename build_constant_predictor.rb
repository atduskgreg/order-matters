require 'csv'

if ARGV.length < 1
	puts "Usage: ruby build_constant_predictor.rb path/to/multinomial.csv <optional/output.csv>"
	puts "* Expects multinomial as csv with columns: rating,proportion."
	exit
end

path_to_multinomial = ARGV[0]
path_to_output = ARGV[1]

multinomial = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0}

rows = CSV.parse(open(path_to_multinomial).read)
rows.each_with_index do |row, i|
	if i > 0 # skip header row
		multinomial[row[0].to_i] = row[1].to_f
	end
end

mse = {}
multinomial.each do |rating, probability|
	mse[rating] = 0
	[1,2,3,4,5].each do |i|
		puts "#{multinomial[i]} * (#{rating}-#{i})**2"
		mse[rating] = mse[rating] + (multinomial[i] * (rating-i)**2)
	end
end

mse.each do |k,v|
	mse[k] = v / mse.length
end


mse.sort_by{|k,v| v }.each do |k,v|
	puts "Prediction: #{k}\tMSE: #{v}"
end

if path_to_output
	CSV.open(path_to_output, "wb") do |csv|
		csv << ["prediction", "mean squared error"]
		mse.each do |prediction,error|
			csv << [prediction, error]
		end
	end

	puts "saved #{path_to_output}"
end