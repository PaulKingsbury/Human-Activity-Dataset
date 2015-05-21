# Human-Activity-Dataset
Repo for analysis of Human Activity Dataset from UCI for Data Science on Coursera

This repository contains one script for analysis of the UCI Human Activity Dataset.  The dataset and collection protocol is described at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.  The script is designed to do the following:

    Merge[s] the training and the test sets to create one data set.
    Extract[s] only the measurements on the mean and standard deviation for each measurement. 
    Use[s] descriptive activity names to name the activities in the data set
    Appropriately label[s] the data set with descriptive variable names. 
    From the data set in step 4, create[s] a second, independent tidy data set with the average of each variable for each activity and each subject.
(from: https://class.coursera.org/getdata-014/human_grading/view/courses/973501/assessments/3/submissions)

## Assumptions
The script should be run in a directory containing the unzipped data from UCI.  The script can be run either from the unzipped UCI HAR directory (../blah/UCI HAR Dataset/), or from the parent directory containing the UCI HAR directory (../blah/).  If neither of these conditions are met, the dataset will be downloaded and unzipped in the current working directory.

