# This script prepares a tidy data set for the Getting and Cleaning Data course project.


################################
# 1. Merges the training and the test sets to create one data set
################################

# Read in the files
features <- read.table('./UCI HAR Dataset/features.txt')
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# data set for training and test data
dataset <- rbind(x_train, x_test)

# labels for training and test lables
datalabels <- rbind(y_train,y_test)

# subjects for both data sets
subjects <- rbind(subject_train, subject_test)


################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
################################

myMeasures <- grep("-(mean|std)\\(\\)", features[,2])
dataset <- dataset[,myMeasures]
names(dataset) <- features[myMeasures, 2]


################################
# 3. Uses descriptive activity names to name the activities in the data set
################################

datalabels[,1] <- activity_labels[datalabels[,1],2]
names(datalabels) <- "Activity"


################################
# 4. Appropriately labels the data set with descriptive variable names
################################

names(subjects) <- "Subject"
allData <- cbind(subjects,datalabels,dataset)


################################
# 5.
################################

library(plyr)

allDataAverages <- ddply(allData, .(Subject,Activity),function(x) colMeans(x[, 3:68]))

write.table(allDataAverages, "tidyData.txt", row.names=FALSE, quote=FALSE,sep='\t')

