---
title: "README"
author: "Paul G. Smith"
date: "12/27/2015"
output: html_document
---

# Getting and Cleaning Data Course Project


### Overview

NOTE!!! for easier reading in RStudio, click **Preview HTML** from the markdown window.

Alternatively, you may also view **README.html** (the HTML version of this file)

In addition, the main directory also contains a CodeBook in two equivalent versions: R Markdown (CodeBook.md) and HTML (CodeBook.html) which describe the detailed variable information.

### Project Assignment

This is the Getting and Cleaning Data Course Project for the Getting and Cleaning Data Course (getdata-035) completed by Paul Smith in December, 2015.

The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set.

*For this project I used the "Human Activity Recogniton Using Smartphones Data Set" which is available from the UCI Machine Learning Repository. A full description of the data set can be found at:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
You should create one R script called run_analysis.R that does the following. 

1.Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!


### How to Execute My Analyis (run_analysis.R)

This file describes how to use my run_analysis.R script for the Getting
and Cleaning Data Course.

Just a quick overall comment here: I chose to output my data in a very narrow format. The **cleanDataSet contains 679,734 rows**; one for each combination of dimension (66) and observation (10,299). The **TidyDataSet contains 11,880 rows**; one for each combination of activty(6) * subject (30) * dimension (66).

1. Set up a new working directory for this project on your local computer.

2. Create a "data" folder in this directory, download the data set from the URL below, and extract the data into this "data" folder.

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

3. Download the my analysis script from the URL below, and save it in the main directory as "run_analysis.R". Make sure the folder "data" and the "run_analysis.R"" script are both in the current working directory.

https://github.com/pgsmith2000/Coursera-Getting-and-Cleaning-Data/blob/master/run_analysis.R

4. In R (or RStudio), run the program:

        source("run_analysis.R")

5. Look for the two output files in your working directory:
        * clean_data.txt contains the data for the data.frame "cleanData" with 679,734 rows (10,299 observations * 66 measurement dimensions) for 30 subjects.
        * tidy_data_with_averages.txt contains the data for a data.frame "tidyDataSet" with 11,880 rows (30 subjects * 6 activities * 66 mean averages for each measurement dimension).
        
To read the file, use the command:

        data <- read.table("tidy_data_with_averages.txt")
        

To view the entire data set, use the following command:

        View(data)

Each row contains the data for one activity (LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS), one subject (1 to 30), and one measurement dimension (1 to 66 dimension means or standard deviations)


### Details for (run_analysis.R) and How It Works



```r
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
```

```
## data.table   reshape2       plyr      dplyr        XML      tidyr 
##       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
##      knitr  rmarkdown 
##       TRUE       TRUE
```

```r
path <- getwd()
path
```

```
## [1] "C:/Users/paul.smith/Documents/Rprojects/Coursera-Getting-and-Cleaning-Data"
```

```r
pathtoData <- file.path(path, "Data")
list.files(pathtoData, recursive = TRUE)
```

```
##  [1] "activity_labels.txt"                         
##  [2] "features.txt"                                
##  [3] "features_info.txt"                           
##  [4] "getdata-projectfiles-UCI HAR Dataset.zip"    
##  [5] "README.txt"                                  
##  [6] "test/Inertial Signals/body_acc_x_test.txt"   
##  [7] "test/Inertial Signals/body_acc_y_test.txt"   
##  [8] "test/Inertial Signals/body_acc_z_test.txt"   
##  [9] "test/Inertial Signals/body_gyro_x_test.txt"  
## [10] "test/Inertial Signals/body_gyro_y_test.txt"  
## [11] "test/Inertial Signals/body_gyro_z_test.txt"  
## [12] "test/Inertial Signals/total_acc_x_test.txt"  
## [13] "test/Inertial Signals/total_acc_y_test.txt"  
## [14] "test/Inertial Signals/total_acc_z_test.txt"  
## [15] "test/subject_test.txt"                       
## [16] "test/X_test.txt"                             
## [17] "test/y_test.txt"                             
## [18] "train/Inertial Signals/body_acc_x_train.txt" 
## [19] "train/Inertial Signals/body_acc_y_train.txt" 
## [20] "train/Inertial Signals/body_acc_z_train.txt" 
## [21] "train/Inertial Signals/body_gyro_x_train.txt"
## [22] "train/Inertial Signals/body_gyro_y_train.txt"
## [23] "train/Inertial Signals/body_gyro_z_train.txt"
## [24] "train/Inertial Signals/total_acc_x_train.txt"
## [25] "train/Inertial Signals/total_acc_y_train.txt"
## [26] "train/Inertial Signals/total_acc_z_train.txt"
## [27] "train/subject_train.txt"                     
## [28] "train/X_train.txt"                           
## [29] "train/y_train.txt"
```

```r
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
```

```
## [1] 2947  561
```

```r
str(dataTest)
```

```
## Classes 'data.table' and 'data.frame':	2947 obs. of  561 variables:
##  $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
##  $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
##  $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
##  $ V4  : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
##  $ V5  : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
##  $ V6  : num  -0.668 -0.945 -0.963 -0.967 -0.978 ...
##  $ V7  : num  -0.953 -0.987 -0.994 -0.995 -0.994 ...
##  $ V8  : num  -0.925 -0.968 -0.971 -0.974 -0.966 ...
##  $ V9  : num  -0.674 -0.946 -0.963 -0.969 -0.977 ...
##  $ V10 : num  -0.894 -0.894 -0.939 -0.939 -0.939 ...
##  $ V11 : num  -0.555 -0.555 -0.569 -0.569 -0.561 ...
##  $ V12 : num  -0.466 -0.806 -0.799 -0.799 -0.826 ...
##  $ V13 : num  0.717 0.768 0.848 0.848 0.849 ...
##  $ V14 : num  0.636 0.684 0.668 0.668 0.671 ...
##  $ V15 : num  0.789 0.797 0.822 0.822 0.83 ...
##  $ V16 : num  -0.878 -0.969 -0.977 -0.974 -0.975 ...
##  $ V17 : num  -0.998 -1 -1 -1 -1 ...
##  $ V18 : num  -0.998 -1 -1 -0.999 -0.999 ...
##  $ V19 : num  -0.934 -0.998 -0.999 -0.999 -0.999 ...
##  $ V20 : num  -0.976 -0.994 -0.993 -0.995 -0.993 ...
##  $ V21 : num  -0.95 -0.974 -0.974 -0.979 -0.967 ...
##  $ V22 : num  -0.83 -0.951 -0.965 -0.97 -0.976 ...
##  $ V23 : num  -0.168 -0.302 -0.618 -0.75 -0.591 ...
##  $ V24 : num  -0.379 -0.348 -0.695 -0.899 -0.74 ...
##  $ V25 : num  0.246 -0.405 -0.537 -0.554 -0.799 ...
##  $ V26 : num  0.521 0.507 0.242 0.175 0.116 ...
##  $ V27 : num  -0.4878 -0.1565 -0.115 -0.0513 -0.0289 ...
##  $ V28 : num  0.4823 0.0407 0.0327 0.0342 -0.0328 ...
##  $ V29 : num  -0.0455 0.273 0.1924 0.1536 0.2943 ...
##  $ V30 : num  0.21196 0.19757 -0.01194 0.03077 0.00063 ...
##  $ V31 : num  -0.1349 -0.1946 -0.0634 -0.1293 -0.0453 ...
##  $ V32 : num  0.131 0.411 0.471 0.446 0.168 ...
##  $ V33 : num  -0.0142 -0.3405 -0.5074 -0.4195 -0.0682 ...
##  $ V34 : num  -0.106 0.0776 0.1885 0.2715 0.0744 ...
##  $ V35 : num  0.0735 -0.084 -0.2316 -0.2258 0.0271 ...
##  $ V36 : num  -0.1715 0.0353 0.6321 0.4164 -0.1459 ...
##  $ V37 : num  0.0401 -0.0101 -0.5507 -0.2864 -0.0502 ...
##  $ V38 : num  0.077 -0.105 0.3057 -0.0638 0.2352 ...
##  $ V39 : num  -0.491 -0.429 -0.324 -0.167 0.29 ...
##  $ V40 : num  -0.709 0.399 0.28 0.545 0.458 ...
##  $ V41 : num  0.936 0.927 0.93 0.929 0.927 ...
##  $ V42 : num  -0.283 -0.289 -0.288 -0.293 -0.303 ...
##  $ V43 : num  0.115 0.153 0.146 0.143 0.138 ...
##  $ V44 : num  -0.925 -0.989 -0.996 -0.993 -0.996 ...
##  $ V45 : num  -0.937 -0.984 -0.988 -0.97 -0.971 ...
##  $ V46 : num  -0.564 -0.965 -0.982 -0.992 -0.968 ...
##  $ V47 : num  -0.93 -0.989 -0.996 -0.993 -0.996 ...
##  $ V48 : num  -0.938 -0.983 -0.989 -0.971 -0.971 ...
##  $ V49 : num  -0.606 -0.965 -0.98 -0.993 -0.969 ...
##  $ V50 : num  0.906 0.856 0.856 0.856 0.854 ...
##  $ V51 : num  -0.279 -0.305 -0.305 -0.305 -0.313 ...
##  $ V52 : num  0.153 0.153 0.139 0.136 0.134 ...
##  $ V53 : num  0.944 0.944 0.949 0.947 0.946 ...
##  $ V54 : num  -0.262 -0.262 -0.262 -0.273 -0.279 ...
##  $ V55 : num  -0.0762 0.149 0.145 0.1421 0.1309 ...
##  $ V56 : num  -0.0178 0.0577 0.0406 0.0461 0.0554 ...
##  $ V57 : num  0.829 0.806 0.812 0.809 0.804 ...
##  $ V58 : num  -0.865 -0.858 -0.86 -0.854 -0.843 ...
##  $ V59 : num  -0.968 -0.957 -0.961 -0.963 -0.965 ...
##  $ V60 : num  -0.95 -0.988 -0.996 -0.992 -0.996 ...
##  $ V61 : num  -0.946 -0.982 -0.99 -0.973 -0.972 ...
##  $ V62 : num  -0.76 -0.971 -0.979 -0.996 -0.969 ...
##  $ V63 : num  -0.425 -0.729 -0.823 -0.823 -0.83 ...
##  $ V64 : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ V65 : num  0.219 -0.465 -0.53 -0.7 -0.302 ...
##  $ V66 : num  -0.43 -0.51 -0.295 -0.343 -0.482 ...
##  $ V67 : num  0.431 0.525 0.305 0.359 0.539 ...
##  $ V68 : num  -0.432 -0.54 -0.315 -0.375 -0.596 ...
##  $ V69 : num  0.433 0.554 0.326 0.392 0.655 ...
##  $ V70 : num  -0.795 -0.746 -0.232 -0.233 -0.493 ...
##  $ V71 : num  0.781 0.733 0.169 0.176 0.463 ...
##  $ V72 : num  -0.78 -0.737 -0.155 -0.169 -0.465 ...
##  $ V73 : num  0.785 0.749 0.164 0.185 0.483 ...
##  $ V74 : num  -0.984 -0.845 -0.429 -0.297 -0.536 ...
##  $ V75 : num  0.987 0.869 0.44 0.304 0.544 ...
##  $ V76 : num  -0.989 -0.893 -0.451 -0.311 -0.553 ...
##  $ V77 : num  0.988 0.913 0.458 0.315 0.559 ...
##  $ V78 : num  0.981 0.945 0.548 0.986 0.998 ...
##  $ V79 : num  -0.996 -0.911 -0.335 0.653 0.916 ...
##  $ V80 : num  -0.96 -0.739 0.59 0.747 0.929 ...
##  $ V81 : num  0.072 0.0702 0.0694 0.0749 0.0784 ...
##  $ V82 : num  0.04575 -0.01788 -0.00491 0.03227 0.02228 ...
##  $ V83 : num  -0.10604 -0.00172 -0.01367 0.01214 0.00275 ...
##  $ V84 : num  -0.907 -0.949 -0.991 -0.991 -0.992 ...
##  $ V85 : num  -0.938 -0.973 -0.971 -0.973 -0.979 ...
##  $ V86 : num  -0.936 -0.978 -0.973 -0.976 -0.987 ...
##  $ V87 : num  -0.916 -0.969 -0.991 -0.99 -0.991 ...
##  $ V88 : num  -0.937 -0.974 -0.973 -0.973 -0.977 ...
##  $ V89 : num  -0.949 -0.979 -0.975 -0.978 -0.985 ...
##  $ V90 : num  -0.903 -0.915 -0.992 -0.992 -0.994 ...
##  $ V91 : num  -0.95 -0.981 -0.975 -0.975 -0.986 ...
##  $ V92 : num  -0.891 -0.978 -0.962 -0.962 -0.986 ...
##  $ V93 : num  0.898 0.898 0.994 0.994 0.994 ...
##  $ V94 : num  0.95 0.968 0.976 0.976 0.98 ...
##  $ V95 : num  0.946 0.966 0.966 0.97 0.985 ...
##  $ V96 : num  -0.931 -0.974 -0.982 -0.983 -0.987 ...
##  $ V97 : num  -0.995 -0.998 -1 -1 -1 ...
##  $ V98 : num  -0.997 -0.999 -0.999 -0.999 -1 ...
##  $ V99 : num  -0.997 -0.999 -0.999 -0.999 -1 ...
##   [list output truncated]
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
# Take a look at the dimensions and structure of dataTrain
dim(dataTrain)
```

```
## [1] 7352  561
```

```r
str(dataTrain)
```

```
## Classes 'data.table' and 'data.frame':	7352 obs. of  561 variables:
##  $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ V4  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ V5  : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ V6  : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ V7  : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
##  $ V8  : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
##  $ V9  : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
##  $ V10 : num  -0.935 -0.943 -0.939 -0.939 -0.942 ...
##  $ V11 : num  -0.567 -0.558 -0.558 -0.576 -0.569 ...
##  $ V12 : num  -0.744 -0.818 -0.818 -0.83 -0.825 ...
##  $ V13 : num  0.853 0.849 0.844 0.844 0.849 ...
##  $ V14 : num  0.686 0.686 0.682 0.682 0.683 ...
##  $ V15 : num  0.814 0.823 0.839 0.838 0.838 ...
##  $ V16 : num  -0.966 -0.982 -0.983 -0.986 -0.993 ...
##  $ V17 : num  -1 -1 -1 -1 -1 ...
##  $ V18 : num  -1 -1 -1 -1 -1 ...
##  $ V19 : num  -0.995 -0.998 -0.999 -1 -1 ...
##  $ V20 : num  -0.994 -0.999 -0.997 -0.997 -0.998 ...
##  $ V21 : num  -0.988 -0.978 -0.965 -0.984 -0.981 ...
##  $ V22 : num  -0.943 -0.948 -0.975 -0.986 -0.991 ...
##  $ V23 : num  -0.408 -0.715 -0.592 -0.627 -0.787 ...
##  $ V24 : num  -0.679 -0.501 -0.486 -0.851 -0.559 ...
##  $ V25 : num  -0.602 -0.571 -0.571 -0.912 -0.761 ...
##  $ V26 : num  0.9293 0.6116 0.273 0.0614 0.3133 ...
##  $ V27 : num  -0.853 -0.3295 -0.0863 0.0748 -0.1312 ...
##  $ V28 : num  0.36 0.284 0.337 0.198 0.191 ...
##  $ V29 : num  -0.0585 0.2846 -0.1647 -0.2643 0.0869 ...
##  $ V30 : num  0.2569 0.1157 0.0172 0.0725 0.2576 ...
##  $ V31 : num  -0.2248 -0.091 -0.0745 -0.1553 -0.2725 ...
##  $ V32 : num  0.264 0.294 0.342 0.323 0.435 ...
##  $ V33 : num  -0.0952 -0.2812 -0.3326 -0.1708 -0.3154 ...
##  $ V34 : num  0.279 0.086 0.239 0.295 0.44 ...
##  $ V35 : num  -0.4651 -0.0222 -0.1362 -0.3061 -0.2691 ...
##  $ V36 : num  0.4919 -0.0167 0.1739 0.4821 0.1794 ...
##  $ V37 : num  -0.191 -0.221 -0.299 -0.47 -0.089 ...
##  $ V38 : num  0.3763 -0.0134 -0.1247 -0.3057 -0.1558 ...
##  $ V39 : num  0.4351 -0.0727 -0.1811 -0.3627 -0.1898 ...
##  $ V40 : num  0.661 0.579 0.609 0.507 0.599 ...
##  $ V41 : num  0.963 0.967 0.967 0.968 0.968 ...
##  $ V42 : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
##  $ V43 : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
##  $ V44 : num  -0.985 -0.997 -1 -0.997 -0.998 ...
##  $ V45 : num  -0.982 -0.989 -0.993 -0.981 -0.988 ...
##  $ V46 : num  -0.878 -0.932 -0.993 -0.978 -0.979 ...
##  $ V47 : num  -0.985 -0.998 -1 -0.996 -0.998 ...
##  $ V48 : num  -0.984 -0.99 -0.993 -0.981 -0.989 ...
##  $ V49 : num  -0.895 -0.933 -0.993 -0.978 -0.979 ...
##  $ V50 : num  0.892 0.892 0.892 0.894 0.894 ...
##  $ V51 : num  -0.161 -0.161 -0.164 -0.164 -0.167 ...
##  $ V52 : num  0.1247 0.1226 0.0946 0.0934 0.0917 ...
##  $ V53 : num  0.977 0.985 0.987 0.987 0.987 ...
##  $ V54 : num  -0.123 -0.115 -0.115 -0.121 -0.122 ...
##  $ V55 : num  0.0565 0.1028 0.1028 0.0958 0.0941 ...
##  $ V56 : num  -0.375 -0.383 -0.402 -0.4 -0.4 ...
##  $ V57 : num  0.899 0.908 0.909 0.911 0.912 ...
##  $ V58 : num  -0.971 -0.971 -0.97 -0.969 -0.967 ...
##  $ V59 : num  -0.976 -0.979 -0.982 -0.982 -0.984 ...
##  $ V60 : num  -0.984 -0.999 -1 -0.996 -0.998 ...
##  $ V61 : num  -0.989 -0.99 -0.992 -0.981 -0.991 ...
##  $ V62 : num  -0.918 -0.942 -0.993 -0.98 -0.98 ...
##  $ V63 : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ V64 : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ V65 : num  0.114 -0.21 -0.927 -0.596 -0.617 ...
##  $ V66 : num  -0.59042 -0.41006 0.00223 -0.06493 -0.25727 ...
##  $ V67 : num  0.5911 0.4139 0.0275 0.0754 0.2689 ...
##  $ V68 : num  -0.5918 -0.4176 -0.0567 -0.0858 -0.2807 ...
##  $ V69 : num  0.5925 0.4213 0.0855 0.0962 0.2926 ...
##  $ V70 : num  -0.745 -0.196 -0.329 -0.295 -0.167 ...
##  $ V71 : num  0.7209 0.1253 0.2705 0.2283 0.0899 ...
##  $ V72 : num  -0.7124 -0.1056 -0.2545 -0.2063 -0.0663 ...
##  $ V73 : num  0.7113 0.1091 0.2576 0.2048 0.0671 ...
##  $ V74 : num  -0.995 -0.834 -0.705 -0.385 -0.237 ...
##  $ V75 : num  0.996 0.834 0.714 0.386 0.239 ...
##  $ V76 : num  -0.996 -0.834 -0.723 -0.387 -0.241 ...
##  $ V77 : num  0.992 0.83 0.729 0.385 0.241 ...
##  $ V78 : num  0.57 -0.831 -0.181 -0.991 -0.408 ...
##  $ V79 : num  0.439 -0.866 0.338 -0.969 -0.185 ...
##  $ V80 : num  0.987 0.974 0.643 0.984 0.965 ...
##  $ V81 : num  0.078 0.074 0.0736 0.0773 0.0734 ...
##  $ V82 : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
##  $ V83 : num  -0.06783 0.02938 -0.00905 -0.00986 0.01678 ...
##  $ V84 : num  -0.994 -0.996 -0.991 -0.993 -0.996 ...
##  $ V85 : num  -0.988 -0.981 -0.981 -0.988 -0.988 ...
##  $ V86 : num  -0.994 -0.992 -0.99 -0.993 -0.992 ...
##  $ V87 : num  -0.994 -0.996 -0.991 -0.994 -0.997 ...
##  $ V88 : num  -0.986 -0.979 -0.979 -0.986 -0.987 ...
##  $ V89 : num  -0.993 -0.991 -0.987 -0.991 -0.991 ...
##  $ V90 : num  -0.985 -0.995 -0.987 -0.987 -0.997 ...
##  $ V91 : num  -0.992 -0.979 -0.979 -0.992 -0.992 ...
##  $ V92 : num  -0.993 -0.992 -0.992 -0.99 -0.99 ...
##  $ V93 : num  0.99 0.993 0.988 0.988 0.994 ...
##  $ V94 : num  0.992 0.992 0.992 0.993 0.993 ...
##  $ V95 : num  0.991 0.989 0.989 0.993 0.986 ...
##  $ V96 : num  -0.994 -0.991 -0.988 -0.993 -0.994 ...
##  $ V97 : num  -1 -1 -1 -1 -1 ...
##  $ V98 : num  -1 -1 -1 -1 -1 ...
##  $ V99 : num  -1 -1 -1 -1 -1 ...
##   [list output truncated]
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
# Take a look at the dimensions and structure of dataSubjectTest
dim(dataSubjectTest)
```

```
## [1] 2947    1
```

```r
str(dataSubjectTest)
```

```
## Classes 'data.table' and 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
# Take a look at the dimensions and structure of dataSubjectTrain
dim(dataSubjectTrain)
```

```
## [1] 7352    1
```

```r
str(dataSubjectTrain)
```

```
## Classes 'data.table' and 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
# Take a look at the dimensions and structure of dataActivityTest
dim(dataActivityTest)
```

```
## [1] 2947    1
```

```r
str(dataActivityTest)
```

```
## Classes 'data.table' and 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
# take a look at the dimensions and structure of dataActivityTrain
dim(dataActivityTrain)
```

```
## [1] 7352    1
```

```r
str(dataActivityTrain)
```

```
## Classes 'data.table' and 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
# take a look at the dimensions and structure of dataFeatures
dim(dataFeatures)
```

```
## [1] 561   2
```

```r
str(dataFeatures)
```

```
## Classes 'data.table' and 'data.frame':	561 obs. of  2 variables:
##  $ featureNum : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ featureName: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
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
```

```
## [1] 10299   563
```

```r
# Step 1: DONE. Training and test sets merged.

###########################################################################
## Step 2. Extract only the measurements on the mean and standard deviation 
##         for each measurement.
###########################################################################

# extract the mean and standard deviations and replace table
dataFeatures <- dataFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]
dim(dataFeatures)
```

```
## [1] 66  2
```

```r
# create a featureCode Variable using "V" and the featureNum
dataFeatures$featureCode <- dataFeatures[, paste0("V", featureNum)]
head(dataFeatures)
```

```
##    featureNum       featureName featureCode
## 1:          1 tBodyAcc-mean()-X          V1
## 2:          2 tBodyAcc-mean()-Y          V2
## 3:          3 tBodyAcc-mean()-Z          V3
## 4:          4  tBodyAcc-std()-X          V4
## 5:          5  tBodyAcc-std()-Y          V5
## 6:          6  tBodyAcc-std()-Z          V6
```

```r
# Step 2: DONE. Measures for means and standard deviations only are extracted

###########################################################################
## Step 3. Uses descriptive activity names to name the activities in the 
## data set. 
###########################################################################

# now subset and sort cleanData to match the featureCode vector
select <- c(key(cleanData), dataFeatures$featureCode)
cleanData <- cleanData[, select, with = FALSE]
dim(cleanData)
```

```
## [1] 10299    68
```

```r
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
```

```
## [1] 679734      5
```

```r
head(cleanData)
```

```
##    subject activityNum activityName featureCode measurement
## 1:       1           1      WALKING          V1   0.2820216
## 2:       1           1      WALKING          V1   0.2558408
## 3:       1           1      WALKING          V1   0.2548672
## 4:       1           1      WALKING          V1   0.3433705
## 5:       1           1      WALKING          V1   0.2762397
## 6:       1           1      WALKING          V1   0.2554682
```

```r
# Step 3: DONE. Activities have descriptive names and these are merged into cleanData

##############################################################
## Step 4. Appropriately labels the data set with descriptive 
## variable names.  
##############################################################

# now merge in the featureNames
cleanData <- merge(cleanData, dataFeatures[, list(featureNum, featureCode, featureName)], 
            by = "featureCode", all.x = TRUE)
dim(cleanData)
```

```
## [1] 679734      7
```

```r
head(cleanData)
```

```
##    featureCode subject activityNum activityName measurement featureNum
## 1:          V1       1           1      WALKING   0.2820216          1
## 2:          V1       1           1      WALKING   0.2558408          1
## 3:          V1       1           1      WALKING   0.2548672          1
## 4:          V1       1           1      WALKING   0.3433705          1
## 5:          V1       1           1      WALKING   0.2762397          1
## 6:          V1       1           1      WALKING   0.2554682          1
##          featureName
## 1: tBodyAcc-mean()-X
## 2: tBodyAcc-mean()-X
## 3: tBodyAcc-mean()-X
## 4: tBodyAcc-mean()-X
## 5: tBodyAcc-mean()-X
## 6: tBodyAcc-mean()-X
```

```r
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
```

```
##         subject         activity              feature featureDomain
##      1:       1           LAYING    fBodyAcc-mean()-X          Freq
##      2:       1           LAYING    fBodyAcc-mean()-X          Freq
##      3:       1           LAYING    fBodyAcc-mean()-X          Freq
##      4:       1           LAYING    fBodyAcc-mean()-X          Freq
##      5:       1           LAYING    fBodyAcc-mean()-X          Freq
##     ---                                                            
## 679730:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
## 679731:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
## 679732:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
## 679733:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
## 679734:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
##         featureAcceleration featureInstrument featureJerk featureMagnitude
##      1:                Body     Accelerometer          NA               NA
##      2:                Body     Accelerometer          NA               NA
##      3:                Body     Accelerometer          NA               NA
##      4:                Body     Accelerometer          NA               NA
##      5:                Body     Accelerometer          NA               NA
##     ---                                                                   
## 679730:             Gravity     Accelerometer          NA        Magnitude
## 679731:             Gravity     Accelerometer          NA        Magnitude
## 679732:             Gravity     Accelerometer          NA        Magnitude
## 679733:             Gravity     Accelerometer          NA        Magnitude
## 679734:             Gravity     Accelerometer          NA        Magnitude
##         featureAxis featureMeasurement Measurement
##      1:           X               Mean -0.99651117
##      2:           X               Mean -0.99593410
##      3:           X               Mean -0.99574989
##      4:           X               Mean -0.99569054
##      5:           X               Mean -0.99556574
##     ---                                           
## 679730:          NA                 SD -0.15870137
## 679731:          NA                 SD -0.15816874
## 679732:          NA                 SD -0.15525182
## 679733:          NA                 SD -0.14853924
## 679734:          NA                 SD -0.09368804
```

```r
dim(cleanData)
```

```
## [1] 679734     11
```

```r
str(cleanData)
```

```
## Classes 'data.table' and 'data.frame':	679734 obs. of  11 variables:
##  $ subject            : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity           : Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...
##  $ feature            : Factor w/ 66 levels "fBodyAcc-mean()-X",..: 27 27 27 27 27 27 27 27 27 27 ...
##  $ featureDomain      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
##  $ featureAcceleration: Factor w/ 3 levels NA,"Body","Gravity": 2 2 2 2 2 2 2 2 2 2 ...
##  $ featureInstrument  : Factor w/ 2 levels "Accelerometer",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ featureJerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 1 1 ...
##  $ featureMagnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 1 1 1 1 ...
##  $ featureAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 2 2 2 2 2 2 2 2 2 ...
##  $ featureMeasurement : Factor w/ 2 levels "Mean","SD": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Measurement        : num  0.282 0.256 0.255 0.343 0.276 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
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
```

```
##         subject         activity              feature featureDomain
##      1:       1           LAYING    fBodyAcc-mean()-X          Freq
##      2:       1           LAYING    fBodyAcc-mean()-X          Freq
##      3:       1           LAYING    fBodyAcc-mean()-X          Freq
##      4:       1           LAYING    fBodyAcc-mean()-X          Freq
##      5:       1           LAYING    fBodyAcc-mean()-X          Freq
##     ---                                                            
## 679730:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
## 679731:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
## 679732:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
## 679733:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
## 679734:      30 WALKING_UPSTAIRS tGravityAccMag-std()          Time
##         featureAcceleration featureInstrument featureJerk featureMagnitude
##      1:                Body     Accelerometer          NA               NA
##      2:                Body     Accelerometer          NA               NA
##      3:                Body     Accelerometer          NA               NA
##      4:                Body     Accelerometer          NA               NA
##      5:                Body     Accelerometer          NA               NA
##     ---                                                                   
## 679730:             Gravity     Accelerometer          NA        Magnitude
## 679731:             Gravity     Accelerometer          NA        Magnitude
## 679732:             Gravity     Accelerometer          NA        Magnitude
## 679733:             Gravity     Accelerometer          NA        Magnitude
## 679734:             Gravity     Accelerometer          NA        Magnitude
##         featureAxis featureMeasurement Measurement
##      1:           X               Mean -0.99651117
##      2:           X               Mean -0.99593410
##      3:           X               Mean -0.99574989
##      4:           X               Mean -0.99569054
##      5:           X               Mean -0.99556574
##     ---                                           
## 679730:          NA                 SD -0.15870137
## 679731:          NA                 SD -0.15816874
## 679732:          NA                 SD -0.15525182
## 679733:          NA                 SD -0.14853924
## 679734:          NA                 SD -0.09368804
```

```r
setkey (TidyDataSet, activity, subject, feature, featureDomain, featureAcceleration, 
        featureInstrument, featureJerk, featureMagnitude, featureAxis, featureMeasurement)
TidyDataSet <- TidyDataSet[, list(count = .N, average = mean(Measurement)), by = key(TidyDataSet)]
dim(TidyDataSet)
```

```
## [1] 11880    12
```

```r
# check with unique values in cleanData (6 activities * 30 subjects * 66 features)
dim(TidyDataSet)[1] == length(unique(cleanData$activity)) * length(unique(cleanData$subject)) * length(unique(cleanData$feature))
```

```
## [1] TRUE
```

```r
write.table(TidyDataSet, "tidy_data_with_averages.txt", row.names = FALSE) # write out the 2nd dataset

# Step 5: DONE

