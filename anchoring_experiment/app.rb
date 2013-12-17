require 'sinatra'
require './models'

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
	@rating = @sequence.ratings.first :position => params[:position]
	@rating.rating = params[:rating]
	@rating.save

	if @sequence.ratings.length == @rating.position + 1
		erb :done
	else 
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
	@sequence.load_movies params["seen"].keys
	@sequence.used = true
	@sequence.save

	redirect "/sequence/#{@sequence.token}/0"
end