## The objective of this script is to create a tidy dataset from assignment files
## The files come from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## The script assumes all this data has been unzip in a directory called UCI HAR Dataset/ on the working directory

## Read for the test data, subject and labels
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- rep("Test",len=nrow(xtest))

## Combine
testdata <- cbind(ytest,subjecttest,xtest,test)
colnames(testdata) = seq(1:length(testdata))

## Idem for the training data, subject and labels
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- rep("Train",len=nrow(xtrain))

## Combine
traindata <- cbind(ytrain,subjecttrain,xtrain,train)
colnames(traindata) = seq(1:length(traindata))

## Merges the training and the test sets to create one data set (1st answer)
data <- rbind(traindata,testdata)

## Uses descriptive activity names to name the activities in the data set (3rd answer)
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
data <- merge(activitylabels,data, by.x=1,by.y=1)

## Assign column names
## First read features
features <- read.table("./UCI HAR Dataset/features.txt")

## Now label the columns (4th answer)        
colnames(data) <- c("activityid","activityname","subjectid",as.character(features[,2]),"train/test")
  
## Now we select the columns referring to a mean or standard deviation (2nd answer)

meanorstd <- grep("(mean\\(\\)|std\\(\\))",colnames(data),value=TRUE)

meanorstddata <- data[,c("activityname","subjectid",meanorstd)]

# To solve the fifth question we use the reshape2 library 

library(reshape2)

meltedmeanorstddata <- melt(meanorstddata,id=c("activityname","subjectid"),measure.vars=meanorstd)

castdata <- dcast(meltedmeanorstddata, activityname + subjectid ~ variable, mean)

# And we save to a file
write.table(castdata, "data.txt",row.name=FALSE)