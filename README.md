## Order Matters

Code related to my current research work on [accounting for anchoring bias on user labeling in machine learning systems](http://urbanhonking.com/ideasfordozens/2013/11/01/research-proposal-accounting-for-anchoring-bias-on-user-labeling-in-machine-learning-systems/)

The code assumes you have the [MovieLens 100k dataset](http://www.grouplens.org/datasets/movielens/). It loads the data in order to look for statistical evidence of influence of sequential recommendations.

### TODO

* Compare 100k_pair_probabilities.csv to 100k_observed_pair_distribution.csv to look for a statistically significant difference (pairwise t-test?)

* Add some better explanation of how to reproduce the results. (Rake-based build script?)

* Movie info about data file formats into a central place