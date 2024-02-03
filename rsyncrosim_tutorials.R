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

# Connecting to R SyncroSim using session
# connects to SyncroSim software

mySession <- session("C:/Program Files/SyncroSim") # created Session based on SyncroSim install folder
mySession # Displaying Session object

version(mySession) #2.5.6


### Installing SyncroSim Packages using addPackages() ###

# get list of installed packages
package()

# see which packages you do not have installed yet
availablePackages <- package(installed = FALSE)
head(availablePackages)

# Install helloworldTime
addPackage("helloworldTime")

package() #checking if helloworldTime is included in package list now - it is!

# to update package use: updatePackage()
# to remove package use: removePackage()


### Create a model workflow ###

# Library > Projects > Scenarios

### Create new library using ssimLibrary() ###

# a library is a file (with .ssm extension) that stores all model inputs and outputs

# Create new Library 
myLibrary <- ssimLibrary(name = "helloworldLibrary.ssim",
                         session = mySession,
                         package = "helloworldTime")
# Check Library info
myLibrary

