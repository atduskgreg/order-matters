require 'open-uri'
require './models'
require 'nokogiri'

PUBLIC_IMAGE_DIR = "#{File.expand_path(File.dirname(__FILE__))}/../public/images/movies"

Movie.all.each_with_index do |movie, i|
	puts "#{i+1}/#{Movie.count}"

	if FileTest.exists? "#{PUBLIC_IMAGE_DIR}/#{URI::encode movie.title}.jpg"
		puts "Already have image for: #{movie.title}. Skipping..."
		next
	end

	begin
		# compose imdb url
		query_url = "http://www.imdb.com/xml/find?xml=1&nr=1&tt=on&q=#{URI::encode movie.title}"
		puts "fetch and parse xml"
		# parse imdb result to get movie id
		xml = Nokogiri::XML( open(query_url) )
		node = xml.xpath("//ResultSet/ImdbEntity/Description/text()").select{|node| node.text =~ /^#{movie.year}/}[0]
		imdb_id = node.parent.parent.attributes["id"].value
	
		# fetch imdb page
		puts "fetch imdb page"
		imdb_page_url = "http://www.imdb.com/title/#{imdb_id}/"
		html = Nokogiri::HTML( open(imdb_page_url) )
		# extract movie image url
		img_url = html.css("#img_primary .image img")[0].attributes["src"].value
	
		puts "save img"
		#save img
		File.open("#{PUBLIC_IMAGE_DIR}/#{URI::encode movie.title}.jpg", "wb"){|f| f << open(img_url).read}
	rescue Exception => e
		puts "ERROR: [Moive: #{movie.id} #{movie.title}] #{e}"
	end
end