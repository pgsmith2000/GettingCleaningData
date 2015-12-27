## run_analysis.R
##
## Getting and Cleaning Data
## Course Project
## 
## Last Updated: 12/26/2015


######################################################################
##  Preliminaries
######################################################################

## Loading Required Packages
packages <- c("data.table", "reshape2", "plyr", "dplyr", "XML", "tidyr", "knitr", "rmarkdown")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

path <- getwd()
path

pathtoData <- file.path(path, "Data")
list.files(pathtoData, recursive = TRUE)


############################################################################
##  Step 1. Merges the training set with the test set to create one data set
############################################################################

# Read in the Training and Test Data

dataTrain <- data.table(fread(file.path(pathtoData, "train", "X_train.txt")))
dataTest <- data.table(fread(file.path(pathtoData, "test", "X_test.txt")))

# Read in the Subject data

dataSubjectTrain <- data.table(fread(file.path(pathtoData, "train", "subject_train.txt")))
dataSubjectTest <- data.table(fread(file.path(pathtoData, "test", "subject_test.txt")))

# Read in the Activity data
dataActivityTrain <- data.table(fread(file.path(pathtoData, "train", "Y_train.txt")))
dataActivityTest <- data.table(fread(file.path(pathtoData, "test", "Y_test.txt")))

# Read in the features file and set the variable names
dataFeatures <- fread(file.path(pathtoData, "features.txt"))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))


# Take a look at the dimensions and structure of dataTest
dim(dataTest)
str(dataTest)

# Take a look at the dimensions and structure of dataTrain
dim(dataTrain)
str(dataTrain)

# Take a look at the dimensions and structure of dataSubjectTest
dim(dataSubjectTest)
str(dataSubjectTest)

# Take a look at the dimensions and structure of dataSubjectTrain
dim(dataSubjectTrain)
str(dataSubjectTrain)

# Take a look at the dimensions and structure of dataActivityTest
dim(dataActivityTest)
str(dataActivityTest)

# take a look at the dimensions and structure of dataActivityTrain
dim(dataActivityTrain)
str(dataActivityTrain)

# take a look at the dimensions and structure of dataFeatures
dim(dataFeatures)
str(dataFeatures)

# merge the subject tables
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(dataSubject, "V1", "subject")

# merge the activity tables
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
setnames(dataActivity, "V1", "activityNum")

# merge the train and test data sets
cleanData <- rbind(dataTrain, dataTest)

# then merge subject and activity files, then cbind to the data set
dataSubject <- cbind(dataSubject, dataActivity)
cleanData <- cbind(dataSubject, cleanData)

# now reorder the tables by subject and activity
setkey(cleanData, subject, activityNum)
dim(cleanData)


# Step 1: DONE. Training and test sets merged.

###########################################################################
## Step 2. Extract only the measurements on the mean and standard deviation 
##         for each measurement.
###########################################################################

# extract the mean and standard deviations and replace table
dataFeatures <- dataFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]
dim(dataFeatures)

# create a featureCode Variable using "V" and the featureNum
dataFeatures$featureCode <- dataFeatures[, paste0("V", featureNum)]
head(dataFeatures)

# Step 2: DONE. Measures for means and standard deviations only are extracted

###########################################################################
## Step 3. Uses descriptive activity names to name the activities in the 
## data set. 
###########################################################################

# now subset and sort cleanData to match the featureCode vector
select <- c(key(cleanData), dataFeatures$featureCode)
cleanData <- cleanData[, select, with = FALSE]
dim(cleanData)

# read in the activity labels and set the names
dataActivityNames <- fread(file.path(pathtoData, "activity_labels.txt"))
setnames(dataActivityNames, names(dataActivityNames), c("activityNum", "activityName"))

# then merge the activity names into cleanData
cleanData <- merge(cleanData, dataActivityNames, by = "activityNum", all.x = TRUE)

# now resort cleanData by subject, activityNum, and activityName
setkey(cleanData, subject, activityNum, activityName)

# now melt the table using the key variables and a featureCode variable value
cleanData <- data.table(melt(cleanData, key(cleanData), variable.name = "featureCode", value.name = "measurement"))

# cleanData is now a very narrow table with all the values
dim(cleanData)
head(cleanData)

# Step 3: DONE. Activities have descriptive names and these are merged into cleanData

##############################################################
## Step 4. Appropriately labels the data set with descriptive 
## variable names.  
##############################################################

# now merge in the featureNames
cleanData <- merge(cleanData, dataFeatures[, list(featureNum, featureCode, featureName)], 
            by = "featureCode", all.x = TRUE)
dim(cleanData)
head(cleanData)

# create factor versions of activityName (activity) and featureName(feature)
cleanData$activity <- factor(cleanData$activityName)
cleanData$feature <- factor(cleanData$featureName)

# make a small function to help parse out the variables from the feature
grepfeature <- function(regex) {
        grepl(regex, cleanData$feature)
}

# Based on info in features_info.txt, create a factor variable for the time and
# freqency domain signals (featureDomain; Time and Freq ) using the first letter 
# from feature name and add column to cleanData
n <- 2
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepfeature("^t"), grepfeature("^f")), ncol = nrow(y))
cleanData$featureDomain <- factor(x %*% y, labels = c("Time", "Freq"))

# Next create a factor variable for the acceleration signals (featureAcceleration;
# Body and Gravity) and add column to cleanData
x <- matrix(c(grepfeature("BodyAcc"), grepfeature("GravityAcc")), ncol = nrow(y))
cleanData$featureAcceleration <- factor(x %*% y, labels = c(NA, "Body", "Gravity"))

# parse the instrument types into a factor variable (featureInstrument; 
# Accelerometer and Gyroscope) and add column to cleanData
x <- matrix(c(grepfeature("Acc"), grepfeature("Gyro")), ncol = nrow(y))
cleanData$featureInstrument <- factor(x %*% y, labels = c("Accelerometer", "Gyroscope"))

# now add colums for factor variables featureJerk and featureMagnitude

cleanData$featureJerk <- factor(grepfeature("Jerk"), labels = c(NA, "Jerk"))
cleanData$featureMagnitude <- factor(grepfeature("Mag"), labels = c(NA, "Magnitude"))

# and a column for the axis categories X, Y, and Z
n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepfeature("-X"), grepfeature("-Y"), grepfeature("-Z")), ncol = nrow(y))
cleanData$featureAxis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))

# and finally for the featureMeasurement itself (Mean and SD)
n <- 2
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepfeature("mean()"), grepfeature("std()")), ncol = nrow(y))
cleanData$featureMeasurement <- factor(x %*% y, labels = c("Mean", "SD"))

# Move measurement column to end (create new column Measurement, delete old)
cleanData$Measurement <- cleanData$measurement
cleanData$measurement <- NULL

# clean up unneeded columns
cleanData$featureCode <- NULL
cleanData$featureNum <- NULL
cleanData$activityNum <- NULL
cleanData$activityName <- NULL
cleanData$featureName <- NULL

# reorder variables and sort cleanData
arrange(cleanData, subject, activity, feature, featureDomain, featureAcceleration, 
       featureInstrument, featureJerk, featureMagnitude, featureAxis, featureMeasurement,
       Measurement)

dim(cleanData)
str(cleanData)

write.table(cleanData, "clean_data.txt") # write out the 1st dataset

# Step 4: DONE. Data set is appropriately labeled (and saved as txt file)

#####################################################################
## Step 5. From the data set in step 4, creates a second, independent 
## tidy data set with the average of each variable for each activity 
## and each subject.  
#####################################################################

TidyDataSet <- cleanData

arrange(TidyDataSet, activity, subject, feature, featureDomain, featureAcceleration, 
        featureInstrument, featureJerk, featureMagnitude, featureAxis, featureMeasurement,
        Measurement)
setkey (TidyDataSet, activity, subject, feature, featureDomain, featureAcceleration, 
        featureInstrument, featureJerk, featureMagnitude, featureAxis, featureMeasurement)
TidyDataSet <- TidyDataSet[, list(count = .N, average = mean(Measurement)), by = key(TidyDataSet)]
dim(TidyDataSet)

# check with unique values in cleanData (6 activities * 30 subjects * 66 features)
dim(TidyDataSet)[1] == length(unique(cleanData$activity)) * length(unique(cleanData$subject)) * length(unique(cleanData$feature))


write.table(TidyDataSet, "tidy_data_with_averages.txt", row.names = FALSE) # write out the 2nd dataset

# Step 5: DONE

#####################################################################
## Additional Miscellaneous Commands Used in Development
#####################################################################

# data <- read.table("./tidy_data_with_averages.txt")

# rmarkdown::render("CodeBook.rmd", clean = FALSE)
# rmarkdown::render("run_analysis.R", clean = FALSE)
