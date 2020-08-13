#Install reshape2 package to leverage functions helpful for transforming data between wide and long formats
install.packages("reshape2")
library(reshape2)

#Download the zipped files from the web and unzip them
filename <- "getdata_dataset.zip"

if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

#Read in the activity label and features reference text files, and convert them to characters
#This enables descriptive activity names to be applied activities in the data set
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# Extract only the measurements on the mean and standard deviation for each measurement, matching the relevant text strings and using grep and gsub
meanandsdmeasurements <- grep(".*mean.*|.*std.*", features[,2])
meanandsdmeasurements.names <- features[meanandsdmeasurements,2]
meanandsdmeasurements.names = gsub('-mean', 'Mean', meanandsdmeasurements.names)
meanandsdmeasurements.names = gsub('-std', 'Std', meanandsdmeasurements.names)
meanandsdmeasurements.names <- gsub('[-()]', '', meanandsdmeasurements.names)

# Read the training and test datasets into tables from the downloaded text files,using the integer vector of the features wanted
# Use column binding to combine the columns from the subjects and activities datasets with the training and test data.
train <- read.table("UCI HAR Dataset/train/X_train.txt")[meanandsdmeasurements]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[meanandsdmeasurements]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge the training and test datasets using rowbinding and colnames to add descriptive labels for the subjects and activities
testandtraining <- rbind(train, test)
colnames(testandtraining) <- c("subject", "activity", meanandsdmeasurements.names)

# Convert the activity and subject column data into factors, and add labels to the activities
# Use the melt function to take the data in the wide format and stack a set of columns into a single column of data. 
# To use melt, we specify the data frame, the id variables, and the measured variables (columns of data) to be stacked.
# The code is creating an independent tidy data set with the average of each variable for each activity and each subject.
# The tidy data set is written to a file called tidy.txt using write.table() and using row.name=FALSE, per course instructions.

testandtraining$activity <- factor(testandtraining$activity, levels = activityLabels[,1], labels = activityLabels[,2])
testandtraining$subject <- as.factor(testandtraining$subject)

testandtraining.melted <- melt(testandtraining, id = c("subject", "activity"))
testandtraining.mean <- dcast(testandtraining.melted, subject + activity ~ variable, mean)

write.table(testandtraining.mean, "tidy.txt", row.names = FALSE, quote = FALSE)