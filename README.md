# Getting and Cleaning Data - Course Project

This repo contains the script as required in the course project assignment. The scipt is named `run_analysis.R` and performs the five activities listed

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script assumes that the files has been extracted into a directory called "UCI HAR Dataset" within the working directory of R and can be launched just by sourcing it

`source("run_analysis.R")`

The output of the script is, additionally to several intermediary data frames, a file named data.txt (as required in step 5 above)

Finally a code book with the description of how the script works and the description of the different data structures created is provided
