require 'sinatra'
require './models'

# configure do
# 	# puts File.dirname(__FILE__) + '/public'
# 	set :public, 'public'
# end

get "/movies" do
	@movies = Movie.all :order => :title
	erb :all
end

get "/movie/:movie_id" do
	@movie = Movie.get params[:movie_id]
	erb :rate
end

post "/sequence" do
	raise "yo"
end