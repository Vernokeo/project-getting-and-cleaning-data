# download and unzip files
fileUrl=("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
download.file(fileUrl,destfile = "./getdata_files.zip")
unzip("getdata_files.zip")
# load in labels
activities <-read.table("UCI HAR Dataset/activity_labels.txt")
features <-read.table("UCI HAR Dataset/features.txt")
View(features)
# Metacharacters: .means any character   *means any number of times   |means or 
varnames<-grep(".*mean.*|.*std.*",features$V2,value=TRUE)
View(varnames)
varnames = gsub('-mean', 'mean', varnames)
varnames = gsub('-std', 'std', varnames)
varnames <- gsub('[-()]', '', varnames)
#load in the test data
x_test <-read.table("UCI HAR Dataset/test/X_test.txt")
dim(x_test)
y_test <-read.table("UCI HAR Dataset/test/y_test.txt")
dim(y_test)
subjects_test <-read.table("UCI HAR Dataset/test/subject_test.txt")
dim(subjects_test)
test_data <-cbind(subjects_test, y_test, x_test)
View(test_data)
#load in the train data
x_train <-read.table("UCI HAR Dataset/train/X_train.txt")
dim(x_train)
y_train <-read.table("UCI HAR Dataset/train/y_train.txt")
dim(y_train)
subjects_train <-read.table("UCI HAR Dataset/train/subject_train.txt")
dim(subjects_train)
train_data <-cbind(subjects_train, y_train, x_train)
View(train_data)
# stack the data
stacked_Data <- rbind(train_data, test_data)
colnames(stacked_Data) <- c("subject", "activity", varnames)
View(stacked_Data)
# Reshape the data
library(reshape2)
stacked_Data$activity <- factor(stacked_Data$activity, levels = activities[,1], labels = activities[,2])
stacked_Data$subject <- as.factor(stacked_Data$subject)
stacked_melted <- melt(stacked_Data,id=c("subject", "activity"))
stacked_mean <- dcast(stacked_melted, subject + activity ~ variable, mean)
write.table(stacked_mean, "project.txt", row.names = FALSE, quote = FALSE) 



