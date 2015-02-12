# Description of the script `run_analysis.R`

The script completed the 5 steps in the course project.

First it reads the information coming from the test data thorugh 4 datasets
`xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")`
`ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")`
`subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")`
`test <- rep("Test",len=nrow(xtest))`

The last dataset `test`is just to indicate the information coming from the test set

Then the information is combined through `cbind`

`testdata <- cbind(ytest,subjecttest,xtest,test)`

The columns are named with just a number at this moment with
`colnames(testdata) = seq(1:length(testdata))`

Train data is treated similarly

To finalise step 1 train and test data are combined into `data`
`data <- rbind(traindata,testdata)`

To complete step 3, we get the name of the activities from the relevant data file
`activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")`

And then data is created again including these labels by merging on the first column of both datasets
`data <- merge(activitylabels,data, by.x=1,by.y=1)`


Now we assign significant column names to our `data` (4th step). The features are read directly from the file

`features <- read.table("./UCI HAR Dataset/features.txt")`

And the column names can be assigned through

`colnames(data) <- c("activityid","activityname","subjectid",as.character(features[,2]),"train/test")`

Where we use the three first and last columns whose names are assigned manually and the other using the names in the features file.

To finish second step we now select the names of columns containing  mean() or std() using `grep`

`meanorstd <- grep("(mean\\(\\)|std\\(\\))",colnames(data),value=TRUE)`

and select the data

`meanorstddata <- data[,c("activityname","subjectid",meanorstd)]`

Finally, the fith step is completed leveraging the reshape library. First the data is melted

`meltedmeanorstddata <- melt(meanorstddata,id=c("activityname","subjectid"),measure.vars=meanorstd)`

with identification column the activity name and subject identification. And then we cast the data using the `dcast`function

`castdata <- dcast(meltedmeanorstddata, activityname + subjectid ~ variable, mean)`

The file is created with

`write.table(castdata, "data.txt",row.name=FALSE)`

This `castdata` final file contains 180 observations (the combination of 30 subjects and 6 activities) for each of the 68 variables that were found containing mean() or std()







