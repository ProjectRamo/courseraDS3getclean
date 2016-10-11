Coursera Get and Clean Data Final 
==================================

Readme
-------

This readme file accompanies the final submission.

It has two important components to it:

- It describes the program
- It describes the data that comes out of the program

Let's take these one at a time.

The program itself is heavily commented and contains most of the important details.
If you want a fuller explanation, please open run_analysis.R and take a look through the commented code.

I will provide a briefer, higher level view here.

This script is supposed to perform the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

This requires us to take the 
- unlabeled data from x_test.txt and x_train.txt
-- these are completely unlabelled
- merge the activity id from y_test.txt and y_train.txt 
-- We do this first because the rows of the datasets line up, which won't be true after we merge them
- merge the activity labels from activity_labels.txt
-- We actually look up the label names in the same activity where we merge on the y_label
- merge the feature (or column) names from features.txt
-- We do this before we pick out and remove some columns because otherwise the columns won't line up
- to pick out the features (columns) that are mean and standard deviation


Finally note that there are two ways to present the final output.
You could uncomment out this line:

 spread (sensor, avg) %>% 

and it would make the sensor a column. I think either one is justified because, as the tidy_data article mentions, there is no matter of fact about what consitutes a variable and what is a value. I choose to consider the sensor to be the variable an the sensor-type to be the value of that variable.

Commented Code
----------------

Here is the code to make it obvious:


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

Code Book
------------

Here is the code_book.md copied and pasted as well:

There are four features in the data set:

# activity (type:character)
	The activity is simply one of six activities: 
	1 WALKING
	2 WALKING_UPSTAIRS
	3 WALKING_DOWNSTAIRS
	4 SITTING
	5 STANDING
	6 LAYING
	And each of these comes right out of the activity labels file.

# subject (type:integer)
	This is a number representing one of the 30 subjects. 
	To preserve anonymity, no other identifying information about the subject is in the data.

# sensor (type: character)
	This is a character representing the type of sensor and data.

# avg_reading (type:double)
	This is the average of all the readins of this sensor, on this subject during this activity.

