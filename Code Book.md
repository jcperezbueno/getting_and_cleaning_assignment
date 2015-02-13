# Description of the script `run_analysis.R`

The script completed the 5 steps in the course project.

First it reads the information coming from the test data through 4 datasets:

- `xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")`
- `ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")`
- `subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")`
- `test <- rep("Test",len=nrow(xtest))`

The last dataset `test` is just to indicate that the information comes from the test set.

Then the information is combined through `cbind`

- `testdata <- cbind(ytest,subjecttest,xtest,test)`

The columns are named with just a number at this moment with

- `colnames(testdata) = seq(1:length(testdata))`

Train data is treated similarly.

To finalise **step 1** train and test data are combined into `data`

- `data <- rbind(traindata,testdata)`

To complete **step 3**, we get the name of the activities from the relevant data file

- `activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")`

And then data is created again including these labels by merging on the first column of both datasets

- `data <- merge(activitylabels,data, by.x=1,by.y=1)`


Now we assign significant column names to our `data` (**step 4**). The features are read directly from the file

- `features <- read.table("./UCI HAR Dataset/features.txt")`

And the column names can be assigned through

- `colnames(data) <- c("activityid","activityname","subjectid",as.character(features[,2]),"train/test")`

Where we use the three first and last columns whose names are assigned manually and the other using the names in the features file.

To finish **step 2** we now select the names of columns containing  mean() or std() using `grep`

- `meanorstd <- grep("(mean\\(\\)|std\\(\\))",colnames(data),value=TRUE)`

and select the data

- `meanorstddata <- data[,c("activityname","subjectid",meanorstd)]`

Finally, the **step 5** is completed leveraging the reshape library. First the data is melted

- `meltedmeanorstddata <- melt(meanorstddata,id=c("activityname","subjectid"),measure.vars=meanorstd)`

with identification column the activity name and subject identification. And then we cast the data using the `dcast`function

- `castdata <- dcast(meltedmeanorstddata, activityname + subjectid ~ variable, mean)`

The file is created with

- `write.table(castdata, "data.txt",row.name=FALSE)`

# Description of the data structures created

## xtest and xtrain
Direct readings of the `X_test.txt` and `X_train.txt` data files. Contain 2947 and 7352 observations respectively and 561 variables (both).

## ytest and ytrain
Direct readings of the `y_test.txt` and `y_train.txt` data files. Contain 2947 and 7352 observations respectively and 1 variables (both).

## subjecttest and subjecttrain
Direct readings of the `subject_test.txt` and `subject_train.txt` data files. Contain 2947 and 7352 observations respectively and 1 variables (both).

## test and train
Character vector with the text "test" and "train" (one variable) and the same number of observations as previous files (2947 and 7352 respectively).

## testdata and traindata
Column bind of previous files (in the order ytest,subjecttest,xtest,test for the test and similarly for the train set). They contain therefore 564 (= 1 + 1 + 561 +1) varaibles and 2947 and 7352 observations respectively

The variables have as name a numeric index (from 1 to 564)

## data
This structure is initially created as the row-bind of testdata and traindata. Therefore with 10299 observations and 564 variables.

This structure is transformed in two steps

 1. The first variable (coming from the y_test and y_train files) is merged with the activitylabels structure (see below in the "Support Structures" section) to get the names of the activities. This adds an additional variable to the data structure (which finally contains 10299 observations and 565 variables).

 2. The columns are named as
	- "activityid"
	- "activityname"
	- "subjectid"
	- features structure (see below in the "Support Structures" section)
	- "train/test"

## meanorstddata
This structure is constructed from the previous one selecting the columns
	- "activityname"
	- "subjectid"
	- features (from the features structure) which contain "mean()" or "stdev()"  structure. In order to select those the meanorstd strcture is created also (see below in the "Support Structures" section)

The meanorstddata strcture contains 10299 observations and 68 variables (2 + 66 coming from the meanorstd selection)


## meltedmeanorstddata

Melted transformation of meanorstddata. It contains 4 variables ("activityname","subjectid","variable","value"). The name of observations is 66 features times 10299 observations from the meanorstddata, i.e. 679734 observations.

## castdata and data.txt file

This castdata structure `dcast` meltedmeanorstddata. It contains 180 observations (the combination of 30 subjects and 6 activities). The number of variables is 68. The two fist identify "activityname" and "subjectid". The other 66 are the average of the 66 features as selected previously.

The data.txt file export to a file the contents of castdata

## Support structures


### activitylabels
This structure is the reading of the activity_labels.txt file. It contains 2 variables (activity id and activity label) and 6 different activities (observations). Notice that the script does not assign the variable names in this structure.

### features
This structure is the reading of the features.txt file. It contains 2 variables (feature id and feature label) and 565 observations (the different features measured). Notice that the script does not assign the variable names in this structure.

### meanorstd
This structure is a character vector coming from selecting the elements in the second column of features (see above) what contain the text "mean()" or "stdev()". This produces 66 features (dimension of the meanorstd vector).





