require 'csv'

if ARGV.length < 2
	puts "usage: ruby build_time_histogram.rb path/to/user/sequences.csv bin_width <optional/output/file.csv>"
	exit
end

path_to_csv = ARGV[0]
bin_width = ARGV[1].to_i
path_to_output = ARGV[2]

time_deltas = []
num_zero = 0

header_row = false
CSV.foreach(path_to_csv) do |row|
	if !header_row
		puts "skipping header row"
		header_row = true
		next
	end

	time_delta = row[6].to_i
	if time_delta == 0
		num_zero = num_zero + 1
	end
	time_deltas << time_delta
end

puts "Min: #{time_deltas.min}"
puts "Max: #{time_deltas.max}"
puts "bin_width: #{bin_width}"
puts "Num deltas: #{time_deltas.length}"
puts "Num zero: #{num_zero}"

grouped = time_deltas.group_by{ |x| x / bin_width }
min, max = grouped.keys.minmax
histogram = Hash[min.upto(max).map { |n| [(bin_width*n..bin_width*(n+1)), grouped.fetch(n, [])] }]

histogram.each do |k,v|
	puts "#{k}: #{v.length}"
end

if path_to_output
	CSV.open(path_to_output, "wb") do |csv|
		csv << ["time (days)", "count"]
		histogram.each do |range,items|
			csv << [range.max, items.length]
		end
	end
end
puts
puts


zoomed_histogram = {}

zoomed_histogram[">1000"] = time_deltas.group_by{|x| x > 1000}.values[1]

puts "zoom to bottom bin"

bin_width = 100
bottom_bin = histogram[histogram.keys.first]
grouped = bottom_bin.group_by{ |x| x / bin_width }
min, max = grouped.keys.minmax
bottom_histogram = Hash[min.upto(max).map { |n| [(bin_width*n..bin_width*(n+1)), grouped.fetch(n, [])] }]
bottom_histogram.each do |k,v|
	zoomed_histogram[k] = v
	break if k.max >= 1000
end

parts = path_to_output.split(".")
puts (parts[0] + "_zoomed.csv")
CSV.open(parts[0] + "_zoomed.csv", "wb") do |csv|
	csv << ["time (days)", "count"]
	zoomed_histogram.each do |range,items|
		# n = items ? items.length : 0

		if range.is_a? String
			csv << [range, items.length]
		else
			csv << [range.max, items.length]
		end
	end
end

puts "zoom to bottom bin"

zoomed_histogram = {}
bin_width = 25
bottom_bin = bottom_histogram[bottom_histogram.keys.first]
grouped = bottom_bin.group_by{ |x| x / bin_width }
min, max = grouped.keys.minmax
bottomest_histogram = Hash[min.upto(max).map { |n| [(bin_width*n..bin_width*(n+1)), grouped.fetch(n, [])] }]


bottomest_histogram.each do |k,v|
	zoomed_histogram[k] = v
	break if k.max >= 300
end

puts "0: #{num_zero}"
zoomed_histogram.each do |k,v|

	if k == zoomed_histogram.keys.first
				puts "#{k.min+1}..#{k.max}: #{v.length - num_zero}"

	else
		puts "#{k}: #{v.length}"
	end
end; nil

CSV.open(parts[0] + "_zoom_zoomed.csv", "wb") do |csv|
	csv << ["time (days)", "count"]
	csv << [0, num_zero]
	zoomed_histogram.each do |range,items|

		if range == zoomed_histogram.keys.first
			csv << [range.max, items.length - num_zero]
		else
			csv << [range.max, items.length]
		end
	end
end

# puts zoomed_histogram.inspect
