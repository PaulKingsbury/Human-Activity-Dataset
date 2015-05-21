# Codebook

Operation of run_analysis.R as of 21-May-2015

## Look for the dataset.
Data should either be in the current working directory or a daughter of the current working directory.  If neither of these cases is true, then the dataset is downloaded and unzipped into the current working directory.

```
if (grepl("UCI HAR Dataset$", getwd())) { 
    message("Already in correct working directory") # thus no further action required
    } else if (file.exists("UCI HAR Dataset")) {
        setwd("UCI HAR Dataset")
        message("Moving to UCI HAR directory")
    } else { 
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"        
        download.file(fileURL, "getdata_projectfiles_UCI HAR Dataset.zip", method="curl")
        unzip("getdata_projectfiles_UCI HAR Dataset.zip") # unzip all files
        setwd("UCI HAR Dataset")
        message("Moving to UCI HAR directory")
}
```

## Define labels
In the raw data several variables are unhelpfully labeled.  The six activities measured are coded as numerics 1-6, with the activities themselves defined separately.  The file of activity codes is read as a factor, then the levels converted into text based upon the mapping provided in the "activity_labels.txt" file.

```
activity <- as.factor(read.table("y_train.txt", col.names="Activity")[,1])
levels(activity) <- activity_levels
```

Similarly, numerical identifiers for human subjects are kept in a separate file from the measurements.  These need to be read in.

```
subjnum <- read.table("subject_train.txt", col.names="Subject")
```

## Read measurement data and merge all recorded data
The measurement file is read and `cbind` used to combine the subject numbers, activity labels, and measurements

```
setwd("train")
traindata <- read.table("X_train.txt", col.names=column_labels)
complete_train <- cbind(activity, subjnum, traindata)
```

Repeat this process for both "test" and "train" datasets.
```
bighuge <- rbind(complete_train, complete_test)
```

## Filter merged dataset to only mean and standard deviation measurements
Identify the columns in the measurements which correspond to calculated means and standard deviations, according to the descriptions given in "features_info.txt" within the distributed dataset.  According to this file, means are labeled with a suffix "mean()" and standard deviations with "std()".  Thus these two strings can be used as a pattern for `grep` over the column labels to identify the columns of interest.  Because the subject id's and activity labels have already been added as columns/column labels, a little munging is required to make sure that the output of grep (over the original column labels) corresponds to the column labels in the merged dataset.  This is a kludge.

```
just_these <- grep("mean\\(\\)|std\\(\\)", column_labels)
just_these <- just_these + 2
just_these <- c(1, 2, just_these)
filtered_data <- bighuge[,just_these]
```

## Organize measurements by subject and activity and calculate the mean measurement.  Write the output to file.

```
output_table <- aggregate(. ~ activity + Subject, data=filtered_data, mean)
write.table(output_table, "merged filtered meaned table.txt", row.names=FALSE)
```
