# JoVE-Bootstrap-Function
Bootstrap Function in R for 95% Z distance


This is a simple function for the Denny and Fields et al  paper "Development of new methods for quantifying fish density using underwater stereo-video tools"

The function takes measured Z -Distances (Distance from camera) for a given species, and bootstraps the 95% Z distance for that species using varying sample sizes. In this way, we are able to deturmine how many samples are needed to confidently have described the distance that 95% of all samples were observed. Ideally, the actual sample size of a given study will be larger than the point which the curve asymptotes. 


This function also plots resulting mean 95% Z distance by sample size. 

An example data set is included
