## Order Matters

Code related to my current research work on [accounting for anchoring bias on user labeling in machine learning systems](http://urbanhonking.com/ideasfordozens/2013/11/01/research-proposal-accounting-for-anchoring-bias-on-user-labeling-in-machine-learning-systems/)

The code assumes you have the [MovieLens 100k dataset](http://www.grouplens.org/datasets/movielens/). It loads the data in order to look for statistical evidence of influence of sequential recommendations.

### TODO

* Assuming the ratings are a normal distribution and the movies were presented in random order what is the probability of getting these rating deltas? If these are lower than expected by a statistically significant amount, that would be evidence of bias.

* Does the rating of the previous movie significantly affect the rating of the next movie relative to the average rating for that movie?
