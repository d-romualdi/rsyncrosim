### February 3rd 2024 ###

# R 4.3.2
# DR

### Running rsyncrosim tutorials ###
# must install SyncroSim software first - DONE

# https://syncrosim.github.io/rsyncrosim/

# install rsyncrosim
install.packages("rsyncrosim")

#load package
library(rsyncrosim)


### Introduction to rsyncrosim ###
# https://syncrosim.github.io/rsyncrosim/articles/a01_rsyncrosim_vignette_basic.html

### SyncoSim Package: helloworldTime
# package to introduce timesteps to Syncrosim modeling 
# takes 2 user inputs, runs through linear model, and returns y value as output
# Input: m (slope), and b (intercept)
# Output: model y = mt + b where t is time



