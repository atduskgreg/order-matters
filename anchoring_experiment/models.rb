require 'dm-core'
require 'dm-migrations'
require 'open-uri'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost:5432/anchoring_experiment')

class Movie
  include DataMapper::Resource

  property :id, Serial
  property :title, Text
  property :year, Integer
  property :movielens_rating, Float # an average

  def img_url
  	"/images/movies/#{URI::escape URI::escape(title)}.jpg" # yuck
  end

end

DataMapper.finalize