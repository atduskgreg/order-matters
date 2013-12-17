require 'dm-core'
require 'dm-migrations'
require 'open-uri'
require 'SecureRandom'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost:5432/anchoring_experiment')

class Movie
  include DataMapper::Resource

  property :id, Serial
  property :title, Text
  property :year, Integer
  property :movielens_rating, Float # an average

  def img_url
  	"/images/movies/#{URI::escape img_filename}" 
  end

  def img_filename
  	"#{URI::escape(title).gsub(/\.|\:/, "")}.jpg" # yuck
  end

end

class Rating
	include DataMapper::Resource

	property :id, Serial
	property :rating, Integer
	property :position, Integer

	belongs_to :movie
	belongs_to :sequence
end

class Sequence
	include DataMapper::Resource

	property :id, Serial
	property :token, String
	property :completion_token, String
	property :used, Boolean, :default => false
	property :agreement, Boolean, :default => false

	has n, :ratings

	def load_movies keys
		keys.shuffle.each_with_index do |key, position|
			ratings.create :movie => Movie.get(key),
						   :position => position
		end
	end

	def self.create_random
		Sequence.create :token => SecureRandom.urlsafe_base64,
					    :completion_token => SecureRandom.urlsafe_base64
	end
end

DataMapper.finalize