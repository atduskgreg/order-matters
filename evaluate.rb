# load test data
# make predictions with each of these
# count mse or absolute error

def order_ignorant_predict( prev_rating )
	return 4
end

def order_aware_predict( prev_rating )
	h = {1=>2, 2=>2, 3=>3, 4=>3, 5=>4}
	h[prev_rating]
end