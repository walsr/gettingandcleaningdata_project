# Data Science - Coursera
## Project for module "getting and cleaning data"

### Download data
Data are available to download from University of California.

    data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(data_url, destfile = "project_data.zip", method = "curl")
    unzip("project_data.zip")

### Load data set
The dataset includes the following files:
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- 'test/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

#### Load test data set
    x_test <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
    y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
    subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)

#### Load training data set
    x_train <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
    y_train <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
    subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)

### merge test and training data set
Label, subject and training set are combined by column.
Test and training data are merged by rows.

    train_data <- cbind(y_train, subject_train, x_train)
    test_data <- cbind(y_test, subject_test, x_test)
    all_data <- rbind(train_data, test_data)

### labels the data set with descriptive variable names
features.txt is used to set descriptive variable for  column name

    features <- read.csv("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
    setnames(all_data, append(c("activity", "subject"), as.character(features[,2])))

### descriptive activity names to name the activities in the data set
activity labels are used to describe the activity column

    activity_labels <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
    all_data$activity <- as.factor(all_data$activity)
    all_data$activity <- factor(all_data$activity,levels=activity_labels$V1,labels=activity_labels$V2)

### extract only the measurements on the mean and standard deviation for each measurement
only relevant column with mean and standard deviation are extracted and combined into selected_data

    mean_selection <- all_data[grepl("mean()", names(all_data))]
    std_selection <- all_data[grepl("std()", names(all_data))]
    selected_data <- cbind(all_data[1:2], mean_selection, std_selection)

### write independent tidy data set
tidy data set with the average of each variable for each activity and each subject.

    selected_data$subject <- as.factor(selected_data$subject)
    tidy_data <- aggregate(selected_data, by=list(activity = selected_data$activity, subject = selected_data$subject), mean)
    write.table(tidy_data, "tidy_data.txt", sep="\t", row.name=FALSE)
