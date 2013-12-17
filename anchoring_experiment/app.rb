require 'sinatra'
require './models'

get "/agreement" do
	@sequence = Sequence.first :used => false
	erb :agreement
end

post "/agreement/:sequence_token" do
	@sequence = Sequence.first :token => params[:sequence_token]
	@sequence.agreement = true
	@sequence.used = true
	@sequence.save

	redirect "/movies/#{ @sequence.token }"
end

get "/movies/:sequence_token" do
	@movies = Movie.all :order => :title
	@sequence = Sequence.first :token => params[:sequence_token]
	
	if @sequence
		erb :all
	else
		erb :no_token
	end
end

post "/sequence/:sequence_token/:position" do
	@sequence = Sequence.first :token => params[:sequence_token]
	@rating = @sequence.ratings.first :position => params[:position].to_i
	@rating.rating = params[:rating]
	@rating.save

	if @sequence.ratings.length == @rating.position + 1
		erb :done
	else 
		next_position = @rating.position + 1
		redirect "/sequence/#{@sequence.token}/#{next_position}"
	end

end

get "/sequence/:sequence_token/:position" do
	@sequence = Sequence.first :token => params[:sequence_token]
	@rating =  @sequence.ratings.first( :position => params[:position].to_i )

	erb :rate
end

post "/sequence/:sequence_token" do
	@sequence = Sequence.first :token => params[:sequence_token]
	puts "PARAMS: #{params.keys.inspect} #{params.inspect}"
	puts "SEEN: #{params[:seen].inspect}"
	@sequence.load_movies params[:seen].keys
	@sequence.save

	redirect "/sequence/#{@sequence.token}/0"
end