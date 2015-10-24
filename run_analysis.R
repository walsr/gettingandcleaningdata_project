library(data.table)
library(dplyr)

# description

# downlaod data
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(data_url, destfile = "project_data.zip", method = "curl")
unzip("project_data.zip")

# load test data set
x_test <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)

# load training data set
x_train <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
y_train <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)

# 1. merge test and training data set
# column structure: activity, subject, features
train_data <- cbind(y_train, subject_train, x_train)
test_data <- cbind(y_test, subject_test, x_test)
all_data <- rbind(train_data, test_data)

# 4. labels the data set with descriptive variable names
features <- read.csv("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
setnames(all_data, append(c("activity", "subject"), as.character(features[,2])))

# 3. use descriptive activity names to name the activities in the data set
activity_labels <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
all_data$activity <- as.factor(all_data$activity)
all_data$activity <- factor(all_data$activity,levels=activity_labels$V1,labels=activity_labels$V2)

# 2. extract only the measurements on the mean and standard deviation for each measurement
mean_selection <- all_data[grepl("mean()", names(all_data))]
std_selection <- all_data[grepl("std()", names(all_data))]
selected_data <- cbind(all_data[1:2], mean_selection, std_selection)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
selected_data$subject <- as.factor(selected_data$subject)
tidy_data <- aggregate(selected_data, by=list(activity = selected_data$activity, subject = selected_data$subject), mean)
write.table(tidy_data, "tidy_data.txt", sep="\t", row.name=FALSE)
