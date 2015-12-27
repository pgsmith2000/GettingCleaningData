---
title: "CodeBook"
author: "Paul G. Smith"
date: "December 25, 2015"
---

Code Book
========
This CodeBook documents the variable names and descriptions for the `TidyDataSet` created as part of my course project for Coursera Getting and Cleaning Data course (getdata-035), in December, 2015.

Just a quick overall comment here: I chose to output my data in a very narrow format. The **cleanDataSet contains 679,734 rows**; one for each combination of dimension (66) and observation (10,299). The **TidyDataSet contains 11,880 rows**; one for each combination of activty(6) * subject (30) * dimension (66).

*I also added variables that "deconstruct" the dimension names (i.e., fBodyAcc-mean()-X) into component 7 component variables (i.e., featureDomain, featureInstrument, etc.)*

Variable Names and Descriptions
------------------------------

Variable Name       | Description
--------------------|------------
activity            | Factor:  Activities performed by the subjects in this study (6 levels)
subject             | Integer: identifier of the subject who performed the activities.
feature             | Factor:  variable name from study (un-deconstructed)
featureDomain       | Factor:  indicates time or Freq(uency) domain signal for variable
featureAcceleration | Factor:  indicates acceleration signal (Body or Gravity) for variable
featureInstrument   | Factor:  indicates measuring instrument (Accelerometer or Gyroscope) for variable
featureJerk         | Factor:  indicates Jerk signal for variable
featMagnitude       | Factor:  indicates signal magnitude for the variable
featAxis            | Factor:  indicates axial signal direction (X, Y, Z) for the variable
featureMeasurement  | Factor:  inicates type of measurement (Mean or SD)
Count               | Integer: count of data points used to compute `average`
Average             | Integer: Average of each variable for each activity and each subject

Dataset structure
-----------------


```r
str(TidyDataSet)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  12 variables:
##  $ activity           : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ subject            : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ feature            : Factor w/ 66 levels "fBodyAcc-mean()-X",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ featureDomain      : Factor w/ 2 levels "Time","Freq": 2 2 2 2 2 2 2 2 2 2 ...
##  $ featureAcceleration: Factor w/ 3 levels NA,"Body","Gravity": 2 2 2 2 2 2 2 2 2 2 ...
##  $ featureInstrument  : Factor w/ 2 levels "Accelerometer",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ featureJerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 2 2 2 2 ...
##  $ featureMagnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 1 1 1 1 ...
##  $ featureAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 2 3 4 2 ...
##  $ featureMeasurement : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 1 1 2 ...
##  $ count              : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ average            : num  -0.939 -0.867 -0.883 -0.924 -0.834 ...
##  - attr(*, "sorted")= chr  "activity" "subject" "feature" "featureDomain" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

List the key variables in the data table
----------------------------------------


```r
key(TidyDataSet)
```

```
##  [1] "activity"            "subject"             "feature"            
##  [4] "featureDomain"       "featureAcceleration" "featureInstrument"  
##  [7] "featureJerk"         "featureMagnitude"    "featureAxis"        
## [10] "featureMeasurement"
```

Show a few rows of the dataset
------------------------------


```r
TidyDataSet
```

```
##                activity subject               feature featureDomain
##     1:           LAYING       1     fBodyAcc-mean()-X          Freq
##     2:           LAYING       1     fBodyAcc-mean()-Y          Freq
##     3:           LAYING       1     fBodyAcc-mean()-Z          Freq
##     4:           LAYING       1      fBodyAcc-std()-X          Freq
##     5:           LAYING       1      fBodyAcc-std()-Y          Freq
##    ---                                                             
## 11876: WALKING_UPSTAIRS      30   tGravityAcc-std()-X          Time
## 11877: WALKING_UPSTAIRS      30   tGravityAcc-std()-Y          Time
## 11878: WALKING_UPSTAIRS      30   tGravityAcc-std()-Z          Time
## 11879: WALKING_UPSTAIRS      30 tGravityAccMag-mean()          Time
## 11880: WALKING_UPSTAIRS      30  tGravityAccMag-std()          Time
##        featureAcceleration featureInstrument featureJerk featureMagnitude
##     1:                Body     Accelerometer          NA               NA
##     2:                Body     Accelerometer          NA               NA
##     3:                Body     Accelerometer          NA               NA
##     4:                Body     Accelerometer          NA               NA
##     5:                Body     Accelerometer          NA               NA
##    ---                                                                   
## 11876:             Gravity     Accelerometer          NA               NA
## 11877:             Gravity     Accelerometer          NA               NA
## 11878:             Gravity     Accelerometer          NA               NA
## 11879:             Gravity     Accelerometer          NA        Magnitude
## 11880:             Gravity     Accelerometer          NA        Magnitude
##        featureAxis featureMeasurement count    average
##     1:           X               Mean    50 -0.9390991
##     2:           Y               Mean    50 -0.8670652
##     3:           Z               Mean    50 -0.8826669
##     4:           X                 SD    50 -0.9244374
##     5:           Y                 SD    50 -0.8336256
##    ---                                                
## 11876:           X                 SD    65 -0.9540336
## 11877:           Y                 SD    65 -0.9149339
## 11878:           Z                 SD    65 -0.8624028
## 11879:          NA               Mean    65 -0.1376279
## 11880:          NA                 SD    65 -0.3274108
```

Summary of variables
--------------------


```r
summary(TidyDataSet)
```

```
##                activity       subject                  feature     
##  LAYING            :1980   Min.   : 1.0   fBodyAcc-mean()-X:  180  
##  SITTING           :1980   1st Qu.: 8.0   fBodyAcc-mean()-Y:  180  
##  STANDING          :1980   Median :15.5   fBodyAcc-mean()-Z:  180  
##  WALKING           :1980   Mean   :15.5   fBodyAcc-std()-X :  180  
##  WALKING_DOWNSTAIRS:1980   3rd Qu.:23.0   fBodyAcc-std()-Y :  180  
##  WALKING_UPSTAIRS  :1980   Max.   :30.0   fBodyAcc-std()-Z :  180  
##                                           (Other)          :10800  
##  featureDomain featureAcceleration     featureInstrument featureJerk
##  Time:7200     NA     :4680        Accelerometer:7200    NA  :7200  
##  Freq:4680     Body   :5760        Gyroscope    :4680    Jerk:4680  
##                Gravity:1440                                         
##                                                                     
##                                                                     
##                                                                     
##                                                                     
##   featureMagnitude featureAxis featureMeasurement     count      
##  NA       :8640    NA:3240     Mean:5940          Min.   :36.00  
##  Magnitude:3240    X :2880     SD  :5940          1st Qu.:49.00  
##                    Y :2880                        Median :54.50  
##                    Z :2880                        Mean   :57.22  
##                                                   3rd Qu.:63.25  
##                                                   Max.   :95.00  
##                                                                  
##     average        
##  Min.   :-0.99767  
##  1st Qu.:-0.96205  
##  Median :-0.46989  
##  Mean   :-0.48436  
##  3rd Qu.:-0.07836  
##  Max.   : 0.97451  
## 
```

List all possible combinations of features
------------------------------------------


```r
TidyDataSet[, .N, by=c(names(TidyDataSet)[grep("^feat", names(TidyDataSet))])]
```

```
##                         feature featureDomain featureAcceleration
##  1:           fBodyAcc-mean()-X          Freq                Body
##  2:           fBodyAcc-mean()-Y          Freq                Body
##  3:           fBodyAcc-mean()-Z          Freq                Body
##  4:            fBodyAcc-std()-X          Freq                Body
##  5:            fBodyAcc-std()-Y          Freq                Body
##  6:            fBodyAcc-std()-Z          Freq                Body
##  7:       fBodyAccJerk-mean()-X          Freq                Body
##  8:       fBodyAccJerk-mean()-Y          Freq                Body
##  9:       fBodyAccJerk-mean()-Z          Freq                Body
## 10:        fBodyAccJerk-std()-X          Freq                Body
## 11:        fBodyAccJerk-std()-Y          Freq                Body
## 12:        fBodyAccJerk-std()-Z          Freq                Body
## 13:          fBodyAccMag-mean()          Freq                Body
## 14:           fBodyAccMag-std()          Freq                Body
## 15:  fBodyBodyAccJerkMag-mean()          Freq                Body
## 16:   fBodyBodyAccJerkMag-std()          Freq                Body
## 17: fBodyBodyGyroJerkMag-mean()          Freq                  NA
## 18:  fBodyBodyGyroJerkMag-std()          Freq                  NA
## 19:     fBodyBodyGyroMag-mean()          Freq                  NA
## 20:      fBodyBodyGyroMag-std()          Freq                  NA
## 21:          fBodyGyro-mean()-X          Freq                  NA
## 22:          fBodyGyro-mean()-Y          Freq                  NA
## 23:          fBodyGyro-mean()-Z          Freq                  NA
## 24:           fBodyGyro-std()-X          Freq                  NA
## 25:           fBodyGyro-std()-Y          Freq                  NA
## 26:           fBodyGyro-std()-Z          Freq                  NA
## 27:           tBodyAcc-mean()-X          Time                Body
## 28:           tBodyAcc-mean()-Y          Time                Body
## 29:           tBodyAcc-mean()-Z          Time                Body
## 30:            tBodyAcc-std()-X          Time                Body
## 31:            tBodyAcc-std()-Y          Time                Body
## 32:            tBodyAcc-std()-Z          Time                Body
## 33:       tBodyAccJerk-mean()-X          Time                Body
## 34:       tBodyAccJerk-mean()-Y          Time                Body
## 35:       tBodyAccJerk-mean()-Z          Time                Body
## 36:        tBodyAccJerk-std()-X          Time                Body
## 37:        tBodyAccJerk-std()-Y          Time                Body
## 38:        tBodyAccJerk-std()-Z          Time                Body
## 39:      tBodyAccJerkMag-mean()          Time                Body
## 40:       tBodyAccJerkMag-std()          Time                Body
## 41:          tBodyAccMag-mean()          Time                Body
## 42:           tBodyAccMag-std()          Time                Body
## 43:          tBodyGyro-mean()-X          Time                  NA
## 44:          tBodyGyro-mean()-Y          Time                  NA
## 45:          tBodyGyro-mean()-Z          Time                  NA
## 46:           tBodyGyro-std()-X          Time                  NA
## 47:           tBodyGyro-std()-Y          Time                  NA
## 48:           tBodyGyro-std()-Z          Time                  NA
## 49:      tBodyGyroJerk-mean()-X          Time                  NA
## 50:      tBodyGyroJerk-mean()-Y          Time                  NA
## 51:      tBodyGyroJerk-mean()-Z          Time                  NA
## 52:       tBodyGyroJerk-std()-X          Time                  NA
## 53:       tBodyGyroJerk-std()-Y          Time                  NA
## 54:       tBodyGyroJerk-std()-Z          Time                  NA
## 55:     tBodyGyroJerkMag-mean()          Time                  NA
## 56:      tBodyGyroJerkMag-std()          Time                  NA
## 57:         tBodyGyroMag-mean()          Time                  NA
## 58:          tBodyGyroMag-std()          Time                  NA
## 59:        tGravityAcc-mean()-X          Time             Gravity
## 60:        tGravityAcc-mean()-Y          Time             Gravity
## 61:        tGravityAcc-mean()-Z          Time             Gravity
## 62:         tGravityAcc-std()-X          Time             Gravity
## 63:         tGravityAcc-std()-Y          Time             Gravity
## 64:         tGravityAcc-std()-Z          Time             Gravity
## 65:       tGravityAccMag-mean()          Time             Gravity
## 66:        tGravityAccMag-std()          Time             Gravity
##                         feature featureDomain featureAcceleration
##     featureInstrument featureJerk featureMagnitude featureAxis
##  1:     Accelerometer          NA               NA           X
##  2:     Accelerometer          NA               NA           Y
##  3:     Accelerometer          NA               NA           Z
##  4:     Accelerometer          NA               NA           X
##  5:     Accelerometer          NA               NA           Y
##  6:     Accelerometer          NA               NA           Z
##  7:     Accelerometer        Jerk               NA           X
##  8:     Accelerometer        Jerk               NA           Y
##  9:     Accelerometer        Jerk               NA           Z
## 10:     Accelerometer        Jerk               NA           X
## 11:     Accelerometer        Jerk               NA           Y
## 12:     Accelerometer        Jerk               NA           Z
## 13:     Accelerometer          NA        Magnitude          NA
## 14:     Accelerometer          NA        Magnitude          NA
## 15:     Accelerometer        Jerk        Magnitude          NA
## 16:     Accelerometer        Jerk        Magnitude          NA
## 17:         Gyroscope        Jerk        Magnitude          NA
## 18:         Gyroscope        Jerk        Magnitude          NA
## 19:         Gyroscope          NA        Magnitude          NA
## 20:         Gyroscope          NA        Magnitude          NA
## 21:         Gyroscope          NA               NA           X
## 22:         Gyroscope          NA               NA           Y
## 23:         Gyroscope          NA               NA           Z
## 24:         Gyroscope          NA               NA           X
## 25:         Gyroscope          NA               NA           Y
## 26:         Gyroscope          NA               NA           Z
## 27:     Accelerometer          NA               NA           X
## 28:     Accelerometer          NA               NA           Y
## 29:     Accelerometer          NA               NA           Z
## 30:     Accelerometer          NA               NA           X
## 31:     Accelerometer          NA               NA           Y
## 32:     Accelerometer          NA               NA           Z
## 33:     Accelerometer        Jerk               NA           X
## 34:     Accelerometer        Jerk               NA           Y
## 35:     Accelerometer        Jerk               NA           Z
## 36:     Accelerometer        Jerk               NA           X
## 37:     Accelerometer        Jerk               NA           Y
## 38:     Accelerometer        Jerk               NA           Z
## 39:     Accelerometer        Jerk        Magnitude          NA
## 40:     Accelerometer        Jerk        Magnitude          NA
## 41:     Accelerometer          NA        Magnitude          NA
## 42:     Accelerometer          NA        Magnitude          NA
## 43:         Gyroscope          NA               NA           X
## 44:         Gyroscope          NA               NA           Y
## 45:         Gyroscope          NA               NA           Z
## 46:         Gyroscope          NA               NA           X
## 47:         Gyroscope          NA               NA           Y
## 48:         Gyroscope          NA               NA           Z
## 49:         Gyroscope        Jerk               NA           X
## 50:         Gyroscope        Jerk               NA           Y
## 51:         Gyroscope        Jerk               NA           Z
## 52:         Gyroscope        Jerk               NA           X
## 53:         Gyroscope        Jerk               NA           Y
## 54:         Gyroscope        Jerk               NA           Z
## 55:         Gyroscope        Jerk        Magnitude          NA
## 56:         Gyroscope        Jerk        Magnitude          NA
## 57:         Gyroscope          NA        Magnitude          NA
## 58:         Gyroscope          NA        Magnitude          NA
## 59:     Accelerometer          NA               NA           X
## 60:     Accelerometer          NA               NA           Y
## 61:     Accelerometer          NA               NA           Z
## 62:     Accelerometer          NA               NA           X
## 63:     Accelerometer          NA               NA           Y
## 64:     Accelerometer          NA               NA           Z
## 65:     Accelerometer          NA        Magnitude          NA
## 66:     Accelerometer          NA        Magnitude          NA
##     featureInstrument featureJerk featureMagnitude featureAxis
##     featureMeasurement   N
##  1:               Mean 180
##  2:               Mean 180
##  3:               Mean 180
##  4:                 SD 180
##  5:                 SD 180
##  6:                 SD 180
##  7:               Mean 180
##  8:               Mean 180
##  9:               Mean 180
## 10:                 SD 180
## 11:                 SD 180
## 12:                 SD 180
## 13:               Mean 180
## 14:                 SD 180
## 15:               Mean 180
## 16:                 SD 180
## 17:               Mean 180
## 18:                 SD 180
## 19:               Mean 180
## 20:                 SD 180
## 21:               Mean 180
## 22:               Mean 180
## 23:               Mean 180
## 24:                 SD 180
## 25:                 SD 180
## 26:                 SD 180
## 27:               Mean 180
## 28:               Mean 180
## 29:               Mean 180
## 30:                 SD 180
## 31:                 SD 180
## 32:                 SD 180
## 33:               Mean 180
## 34:               Mean 180
## 35:               Mean 180
## 36:                 SD 180
## 37:                 SD 180
## 38:                 SD 180
## 39:               Mean 180
## 40:                 SD 180
## 41:               Mean 180
## 42:                 SD 180
## 43:               Mean 180
## 44:               Mean 180
## 45:               Mean 180
## 46:                 SD 180
## 47:                 SD 180
## 48:                 SD 180
## 49:               Mean 180
## 50:               Mean 180
## 51:               Mean 180
## 52:                 SD 180
## 53:                 SD 180
## 54:                 SD 180
## 55:               Mean 180
## 56:                 SD 180
## 57:               Mean 180
## 58:                 SD 180
## 59:               Mean 180
## 60:               Mean 180
## 61:               Mean 180
## 62:                 SD 180
## 63:                 SD 180
## 64:                 SD 180
## 65:               Mean 180
## 66:                 SD 180
##     featureMeasurement   N
```

