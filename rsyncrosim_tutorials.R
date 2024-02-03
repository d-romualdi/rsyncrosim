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

### Create new Library using ssimLibrary() ###

# a library is a file (with .ssm extension) that stores all model inputs and outputs

# Create new Library 
myLibrary <- ssimLibrary(name = "helloworldLibrary.ssim",
                         session = mySession,
                         package = "helloworldTime")
# Check Library info
myLibrary

# We can also open an existing Library like this:
myLibrary <- ssimLibrary(name = "helloworldLibrary.ssim")
# if you want to create a new Library with an existing file name, you can overwrite it by using overwrite=TRUE for the ssimLibrary() function 

### Open a Project using project() ###

# Projects are found in a SyncroSim Library each represented by a Project obkect in R
# Projects store model inputs that are common to all Scenarios
# Mostly need one Project per Library 
# Each new Library starts with a single Project named "Definitions" (with a unique projectId = 1)
# project() can create and retrieve Projects

# NOTE: ssimObject can be the same of a Library or Scenario

# Open exiting project 
myProject = project(ssimObject = myLibrary, project = "Definitions") # Using name for Project
myProject = project(ssimObject = myLibrary, project = 1) # using projectId for Project

# Check project info
myProject

### Create a new Scenario using scenario() ###

# Each Project contains a Scenario represented by a Scenario object in R
# Scenarios store specific inputs and outputs associated with each Transformer in SyncroSim
# SyncroSim models can be broken down into one or more Transformers
# Each Transformer tuns a series of calculations on the input data to 'transform' it into output data
# Scenarios can contain multiple Transformers connected by series of Pipelines such that one Transformer becomes the input of the next 

# Each Scenario is identified by its unique scenarioId
# scenario() function is used to create and retrieve Scenarios

# NOTE: ssimObject can be the name of a Library or Project 

# Create a new Scenario (associated with default Project)
myScenario = scenario(ssimObject = myProject, scenario = "My first scenario")

# Check Scenario
myScenario


### View model inputs using datasheet() ###

# Each SyncroSim Library contains multiple Datasheets
# Datasheet is a table of data stored in a Library and represent the input and output data for Transformers
# Datasheets have a scope: either Library, Project, or Scenario

# Datasheets with:
# Library scope - represent data that is specified only once for the entire Library (such as location of backup folder)
# Project scope - represent data that are shared over all Scenarios in a Project 
# Scenario scope - represent data that must be specified for each generated Scenario

# View Datasheets of varying scopes using datasheet() function

# View all Datasheets associated with a Library, Project, or Scenario
datasheet(myScenario)

# To see more info on each Datasheet (like scope of Datasheet or if it only accepts a single row of data) we can set optional = TRUE
datasheet(myScenario, optional = TRUE)

# Output shows that RunControl Datasheet and InputDatasheet only accept single row of data (i.e., isSingle = TRUE)

# To view specific Datasheet rather than just a dataframe of available Datasheets, set the name parameter in the datasheet() fn
# syntax is "<name of package>_<name of Datasheet>"
# from list of datasheets, we can see there are 3 Datasheets associated with helloworldTime package

# View the input Datasheet for the Scenario
datasheet(myScenario, name = "helloworldTime_InputDatasheet")
# we are viewing the contents of a SyncroSim Datasheet as an R dataframe


### Configure model inputs using datasheet() and addRow() ###


