### February 4th 2024 ###

# R 4.3.2
# DR

### Running rsyncrosim tutorial: Introduction to Uncertainty ###

# https://syncrosim.github.io/rsyncrosim/

# install rsyncrosim
install.packages("rsyncrosim")

#load package
library(rsyncrosim)


### Introduction to Uncertainty ###
# https://syncrosim.github.io/rsyncrosim/articles/a02_rsyncrosim_vignette_uncertainty.html

# This will cover Monte Carlo realizations for modeling uncertainty 

### SyncroSim Package: helloworldUncertainty ###

# We will use the helloworldUncertainty package to model uncertainty
# Introduces iterations to SyncroSim modeling workflows
# Iterations allows for repreated simulations known as "Monte Carlo realizations" wherein each simulation independently
## sampled from a distrubution of values

# Package takes from 3 inputs: mMean, mSD, and b
# For each iteration, a value m (slope), is sampled from a normal distribution with a mean of mMean and a standard deviation of mSD
# The b value reps the intercept
# These inputs are run through a linear model y = mt + b where t is time, and y is the returned output

### Connect R to SyncroSim using session() ###

mySession <- session("C:/Program Files/SyncroSim") # created Session based on SyncroSim install folder
mySession # Displaying Session object

version(mySession) #2.5.6

### Installing SyncroSim Packages using addPackages() ###

# get list of installed packages
package()

# see which packages you do not have installed yet
availablePackages <- package(installed = FALSE)
head(availablePackages)

# Install helloworldUncertainty
addPackage("helloworldUncertainty")

package() #checking if helloworldUncertainty is included in package list now - it is!

# to update package use: updatePackage()
# to remove package use: removePackage()

### Create a model workflow ###

# Library > Projects > Scenarios

### Create new Library using ssimLibrary() ###

# a library is a file (with .ssm extension) that stores all model inputs and outputs

# Create new Library 
myLibrary <- ssimLibrary(name = "helloworldLibrary.ssim",
                         session = mySession,
                         package = "helloworldUncertainty",
                         overwrite = TRUE)
# Open the default Project
myProject = project(ssimObject = myLibrary, project = "Definitions")

# Create a new Scenario (associated with the default Project)
myScenario = scenario(ssimObject = myProject, scenario = "My first scenario")



### View model inputs using datasheet() ###

# View all Datasheets associated with a Library, Project, or Scenario
datasheet(myScenario)
# 3 Datahseets associated with the helloworldUncertainty package

# View the contents of the input Datasheet for the Scenario
datasheet(myScenario, name = "helloworldUncertainty_InputDatasheet")
# empty!


### Configure model inputs using datahseet() and addRow()

### Input Datasheet ###

# Load the input Datahseet to an R data frame
myInputDataframe <- datasheet(myScenario,
                              name = "helloworldUncertainty_InputDatasheet")
# Check the columns of the input df
str(myInputDataframe)
# Input Datasheet requires: 
# mMEan - the mean of the slope normal distribution
# mSD - the standard deviation of the slope normal distribution 
# b - intercept of linear equation 

# Add these values to a new df, then use addRow() to update the input df

# Create input and add it to input df
myInputRow <- data.frame(mMean = 2, mSD = 4, b = 3)
myInputDataframe <- addRow(myInputDataframe, myInputRow)

# Check values
myInputDataframe

# Save input R data frame to a SyncroSim Datasheet
saveDatasheet(ssimObject = myScenario, data = myInputDataframe,
              name = "helloworldUncertainty_InputDatasheet")
## Datasheet <helloworldUncertainty_InputDatasheet> saved



### RunControl Datasheet ###

# RunControl Datasheet provides info about how many time steps and iterations to use in the model
# Here we set the number of iterations, as well as the min and max time steps of our model
# Number of iterations we set is equivalent to the number of Monte Carlo realizations
## So the greater the number of iterations, the more accurate the range of output values we will obtain

# Look at the columns that need input values

# Load RunControl Datasheet to a new R df
runSettings <- datasheet(myScenario, name = "helloworldUncertainty_RunControl")

# Check the columns of RunControl df
str(runSettings)

### ERROR in RunControl Datasheet
# Missing MinimumIteration column 
# I am adding it below

# DR - add missing column MinimumIteration 
df_MinIt <- data.frame(MinimumIteration = 1)

# Create run control data and add it to the run control data frame
runSettingsRow <- data.frame(MaximumIteration = 5,
                             MinimumTimestep = 1, 
                             MaximumTimestep = 10)

# DR - add df_MinIt column to runSettingsRow
runSettingsRow_2 <- cbind(runSettingsRow, df_MinIt)

# rename runSettingsRow_2 as runSettings
runSettings <- runSettingsRow_2

# Check 
runSettings

# Save RunControl R df to a SyncroSim Datasheet
saveDatasheet(ssimObject = myScenario, data = runSettings,
              name = "helloworldUncertainty_RunControl")
## Datasheet <helloworldUncertainty_RunControl> saved


### Run Scenarios ###

### Setting run parameters with run() ###

# If we have a large model and want to parallelize the run using multiprocessing, we can set the jobs argument to have a greater value than 1
# Since we are using 5 iterations in our model, we will set the numer of jobs to 5 so each multiprocessing core will run a single iteration 

# Run first Scenario we created
myResultScenario <- run(myScenario, jobs = 5)

### ERRORS HERE ^^^ External program failed?

# Check that we have two Scenarios, and one is a Result Scenario
scenario(myLibrary)


### View Results ###

### View results with datasheet() ###

# Results of fist Scenario
resultsSummary <- datasheet(myResultScenario,
                            name = "helloworldUncertainty_OutputDatasheet")
# View results table
head(resultsSummary)

### There is an error in the RunControl df
### Results in problems with running the Scenarios...