# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

run_analysis <- function() {
  
}

# I prefer to have the data set in a different directory but the course calls for same directory.
# This function helps me toggle quickly
addpath <- function(filename) {
  path = "UCI HAR Dataset/"
  path="" # remove or replace usually
  return(paste0(path, filename))
}


activity_labels <- read.csv(addpath("activity_labels.txt"), header = FALSE, sep="")
features <- read.csv(addpath("features.txt"), header = FALSE, stringsAsFactors=FALSE, sep="")

subject_train <- read.csv(addpath("train/subject_train.txt"), header = FALSE, sep="")

y_train <-read.csv(addpath("train/y_train.txt"), header = FALSE, sep="")
x_train <- read.csv(addpath("train/X_train.txt"), header = FALSE, sep="")

x_test <- read.csv(addpath("test/X_test.txt"), header = FALSE, sep="")
y_test <- read.csv(addpath("test/y_test.txt"), header = FALSE, sep="")



x_tt <- rbind(x_train, x_test)


# Not that sep="" which means that all consecutive white spaces are joined together. This made a big difference.
# Initially I was getting many extra features (columns) and observations (rows) because each double space generated
# a new feature.

# We know the number of observations should equal the rows of y_train and features equal the rows of features.txt

# Okay so what is in the subject file?
summary(subject_train)
# X1       
# Min.   : 1.00  
# 1st Qu.: 8.00  
# Median :19.00  
# Mean   :17.42  
# 3rd Qu.:26.00 
# This goes from 1-30 so I think it is an id for each subject (there were 30 people who participated)

# What is in the y_train file?
summary(y_train)
# X5       
# Min.   :1.000  
# 1st Qu.:2.000  
# Median :4.000  
# Mean   :3.643  
# 3rd Qu.:5.000  
# Max.   :6.000  

# This looks like the number of the activity since it goes from 1-6 

# let's label the x_train data
head(features[[2]])
colnames(x_train) = features[[2]]
X_train$subjectID = subject_train
X_train$activityID = y_train


# label the y_train and y_test by the appropriate activity

