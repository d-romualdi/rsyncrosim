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

# Currently the input Scenario Datasheets are empty!
# Add values to input Datasheet (InputDatasheet) to run our model

# First, assign the input Datasheet to a new data frame variable

# Assign contents of the input Datasheet to an R data frame
myInputDataframe <- datasheet(myScenario, 
                              name = "helloworldTime_InputDatasheet")

# Check columns that need input values and the type of values these columns need using str() base R fn
# i.e., string, numercial, logical

# Check columns of input df
str(myInputDataframe)

# Input Datasheet requires 2 values
# m : slope of linear equation
# b : intercept of the linear equation

# Now, update the input dataframe using addRow()
# addRow() takes the targetDataframe as the first value (in this case, our input data frame that we want to update)
# and the data frame of new rows to append to the input df as the second value 

# NOTE: we know that the input Datasheet only accepts a single row of values, so we can only have one value each for slope(m) and intercept(b)

# Create input data and add it to input data frame
myInputRow <- data.frame(m = 3, b = 10)
myInputDataframe <- addRow(myInputDataframe, myInputRow)

# Check values
myInputDataframe


### Saving modifications to Datasheets using saveDatasheet() ###

# we can save a Datasheet at the Library, Project, or Scenario level

# Save input R data frame to a SyncroSim Datasheet at the Scneario level
saveDatasheet(ssimObject = myScenario, data = myInputDataframe, 
              name = "helloworldTime_InputDatasheet")
## Datasheet <helloworldTime_InputDatasheet> saved


### Configuring the RunControl Datasheet ###

# we need to configure another Datasheet for our package to run
# RunControl Datasheet provides info about how many time steps to use in the model
# Here, we set minimum and maximum time steps for our model

# Add this information to an R data frame and add it to Run Control Datasheet using addRow()
# We need to specify the following 2 columns:
# MinimumTimestep: the starting point of the simulation
# MaximumTimestep: the end time point of the simulation

# Assign contents of the run control Datasheet to an R df
runSettings <- datasheet(myScenario, name = "helloworldTime_RunControl")

# Check coluns of the run control df
str(runSettings)

# Create run control data and add it to the run control df
runSettingsRow <- data.frame(MinimumTimestep = 1,
                            MaximumTimestep = 10)
runSettings <- addRow(runSettings, runSettingsRow)

# Check values
runSettings

# Save run control R df to a SyncroSum Datasheet
saveDatasheet(ssimObject = myScenario, data = runSettings,
              name = "helloworldTime_RunControl")
## Datasheet <helloworldTime_RunControl> saved



### Run Scenarios ###

### Setting run parameters with run() ###

# Starting with Scenario we created in "My first scenario"

# Run first Scenario we created
myResultScenario <- run(myScenario)
## [1] "Running scenario [1] My first scenario"


### Checking the run log with runLog() ###

# Get run details for the first reult Scenario 
runLog(myResultScenario)


### View Results ###

### Results Scenarios ###

# A Results Scenario is generated when a Senario is run and is an exact copy of the original Scenario (i.e., contains the original Scenario's values for all input Datasheets)
# Results Scenario is passed to the Transformer in order to generate model output, with the results of the Transformer's calculations then being added to the Results Scenario as output Datasheets
# Results Scenario contains both the output of the run, and a snapshot record of all model inputs

# Check current Scenarios in Library using scenario() function 
scenario(myLibrary)

# The first Scenario is our original Scenario, and the second is the Results Scenario with a time, and date stamp of when it was run
# We can also see if the Scenario is a result or not (i.e., isResult = NO/YES)

# We can also look at how the Datasheets differ between the Results Scenario and the original Scenario

# Look at original Scenario Datasheets
datasheet(myScenario, optional = TRUE)

# Look at Results Scenario Datasheets
datasheet(myResultScenario, optional = TRUE)

# looking at data column, the OuputDatasheet does not contain any data (FALSE) in the original Scenario, but does (TRUE) in the Results Scenario


### Viewing results with datasheet() ###

# View the output Datasheet added to Results Scenario when it was run
# Load the results table using datasheet() and setting the name parameter to the Datasheet with new data added

# Results of first Scenario
myOutputDataframe <- datasheet(myResultScenario,
                               name = "helloworldTime_OutputDatasheet")
# view results table
head(myOutputDataframe)


### Working with multiple Scenarios ###

# May want to test multiple alternative Scenarios that have slightly different inputs
# To save time, you can copy a Scenario that you've already made, give it a different name, and modify the inputs
# To copy a completed Scenario, use the scenario() fn with the sourceScenario argument set to the name of the Scenario you want to copy

# Check which Scenarios you currently have in your Library
scenario(myLibrary)['Name']

# Create a new Scenario as a copy of an exisiting Scenario
myNewScenario <- scenario(ssimObject = myProject, 
                          scenario = "My second scenario",
                          sourceScenario = myScenario)

# Make sure this new Scenario has been added to the Library 
scenario(myLibrary)['Name']

# To edit the new Scenatio, we need to load the contents of the input Datasheet and assign it to a new R df using the datasheet() fn
# We will still set the empty argument to TRUE so that instead of getting the same values from the existing Scenario, we can start with an empty df again

# Load empty input Datasheets as an R df
myNewInputDataframe <- datasheet(myNewScenario,
                                 name = "helloworldTime_InputDatasheet",
                                 empty = TRUE)
# Check that we have an empty df
str(myNewInputDataframe)

# Add our df of values the same way we did before using addRow(

# Create input data and add it to the input data frame
newInputRow <- data.frame(m = 4, b = 10)
myNewInputDataframe <- addRow(myNewInputDataframe, newInputRow)

# View new inputs
myNewInputDataframe

# Save updated df to SyncroSim Datasheet using saveDatasheet()

# Save R df to SyncroSim Datasheet
saveDatasheet(ssimObject = myNewScenario, data = myNewInputDataframe,
              name = "helloworldTime_InputDatasheet")
## Datasheet <helloworldTime_InputDatasheet> saved

# Keep RunControl Datasheet the same as the first Scenario


### Run Scenarios ###

# Now we have 2 SyncroSim Scenarios
# We can run all Scenarios in the Project at once by telling run() which Project to use and including a vector of Scenarios in the scenario argument

# Run all Scenarios
myResultScenarioAll <- run(myProject, 
                           scenario = c("My first scenario",
                                        "My second scenario"))


### View Results ###

# Output that is returned from running many Scenarios at once is actually a list of result Scenario objects
# To view results, we can use datasheet() fn
# Just need to index for the result Scenario object we are interested in

datasheet(myResultScenarioAll[2], name = "OutputDatasheet")


### Identifying the parent Scenario of a Results Scenario using parentId() ###

# If you have many alternative Scenarios and many Result Scenarios, you can always find the parent Scenario that was run in order to generate the Results Scenario
# using the parentId() fn

parentId(myResultScenarioAll[[1]])
parentId(myResultScenarioAll[[2]])



### Access model metadata ###

### Getting Library information using info() ###

info(myLibrary)

### Getting information of an ssimObject ###

# Following functions can be used to get info about a Library, Project, or Scenario:
# name() : used to retrieve or assign a name
# owner() : used to retrieve or assign an owner
# dateModified() : used to retrieve the date when the last changes were made
# readOnly() : used to retrieve or assign the read-only status
# filepath() : retrieve local file path
# description() : retrieve or add a description

# You can also find ID numbers of Projects of Scenarios using the folowing fns:
# projectID() : used to retrieve the Project identification number
# scenarioID() : used to retrieve the Scenario identification number

### Backup your Library ###

# May want to backup the inputs and results into zipped .backup subfolder
# First, modify the Library Backup Datasheet to allow backup of model outputs
# Since Datasheet is part of the built-in SyncroSim core, the name of the Datasheet has the prefix "core"
# We can get a list of all the core Datasheets with a Library scope using the datasheet() fn

# Find all core Library-scoped Datasheets
datasheet(myLibrary, summary = "CORE")

# Get the current values for the Library's Backup Datasheet
myDataframe <- datasheet(myLibrary, name = "core_Backup")

# View current values for the Library's Backup Datasheet
myDataframe

# Add output to the Library's Backup Datasheet and save
myDataframe$IncludeOutput <- TRUE
saveDatasheet(myLibrary, data = myDataframe, name = "core_Backup")

## Datasheet <core_Backup> saved

# Check to make sure IncludeOutput is now TRUE
datasheet(myLibrary, "core_Backup")

# Now you can use backup() fn to backup Library, Project, or Scenario
backup(myLibrary)

## Backup complete.

### rsyncrosim and the SyncroSim Windows User Interface ###

# Can use rsyncrosim and SyncroSim Windows UI at the same time
# Can run Scenarios in rsyncrosim and plot outputs in SyncroSim UI as you go
# To sync the Library in the UI with the latest changes in rsyncrosim code, click the refresh icon (top left corner) in the UI

# --- FIN --- #
