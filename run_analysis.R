# This script is supposed to perform the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# However, changing the order makes it easier, so we will actually do

library(dplyr)
library(tidyr)

run_analysis <- function() {
  # I prefer to have the data set in a different directory but the course calls for same directory.
  # This function helps me toggle quickly
  addpath <- function(filename) {
    path = "UCI HAR Dataset/"
    path="" # remove for my home laptop
    return(paste0(path, filename))
  }
  
  # Note that sep="" which means that all consecutive white spaces are joined together. This made a big difference.
  # Initially I was getting many extra features (columns) and observations (rows) because each double space generated
  # a new feature.
  # We know the number of observations should equal the rows of y_train and features equal the rows of features.txt
  
  activity_labels <- read.csv(addpath("activity_labels.txt"), header = FALSE, stringsAsFactors=FALSE, sep="")
  features <- read.csv(addpath("features.txt"), header = FALSE, stringsAsFactors=FALSE, sep="")
  
  
  x_train <- read.csv(addpath("train/X_train.txt"), header = FALSE, sep="")
  y_train <-read.csv(addpath("train/y_train.txt"), header = FALSE, sep="")
  subject_train <- read.csv(addpath("train/subject_train.txt"), header = FALSE, stringsAsFactors=FALSE, sep="")
  
  x_test <- read.csv(addpath("test/X_test.txt"), header = FALSE, sep="")
  y_test <- read.csv(addpath("test/y_test.txt"), header = FALSE, sep="")
  subject_test <- read.csv(addpath("test/subject_test.txt"), header = FALSE, stringsAsFactors=FALSE, sep="")
  
  # give them the appropriate labels
  featurelist <- features$V2
  colnames(x_test) = featurelist
  colnames(x_train) = featurelist
  
  # fortunately we can merge the labels pretty easily because y_test and activity_labels index on "v1"
  # lets merge on activity and store the activity label in a new column called "activity"
  x_test$activity = (merge(y_test, activity_labels) %>% mutate(activity=V2))$activity # %>% select(activity) won't work
  x_train$activity = (merge(y_train, activity_labels) %>% mutate(activity=V2))$activity
  
  # add the subject id too because we will eventually need it
  # the subject stays anonymous so we never merge the label on
  x_train$subject = subject_train$V1
  x_test$subject = subject_test$V1
  
  # merge the test and train data now that activity has been added
  x_test_train <- rbind.data.frame(x_train, x_test)
  
  # Let's extract all the columns which feature the word "std" or "mean(" we need the \\ so that ( doesn't read as a special char
  valid_colnames <- make.names(names=names(x_test_train), unique=TRUE, allow_ = TRUE)
  names(x_test_train) <- valid_colnames # without this, I get duplicate names because the "-" doesnt distinguish the names properly
  x_test_train = select(x_test_train, matches("std|mean\\.|activity|subject"))
  
  # Finally make the new dataframe by gathering the varialbe names, summarizing it and displaying
  x_test_train %>%
    gather (sensor, reading, 1:73) %>%
    group_by(activity, subject, sensor) %>%
    summarize(avg_reading=mean(reading)) %>%
    # spread (sensor, avg) %>% I like it tall and skinny (normalized) but if you want, you could spread() it back out
    return
}

output <- run_analysis()
write.table(output, file="run_analysis_output.txt", row.name=FALSE)
