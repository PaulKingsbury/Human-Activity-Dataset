# program outline
# 1. check working directory
message("Looking for input data")
### in UCI HAR dir?  no op
if (grepl("UCI HAR Dataset$", getwd())) { # current working directory (full path) ends with UCI HAR, so we are in that directory
    message("Already in correct working directory") # thus no further action required
    } else if (file.exists("UCI HAR Dataset")) {
        ### UCI HAR dataset available?  cwd to
        setwd("UCI HAR Dataset")
        message("Moving to UCI HAR directory")
    #} else { # UNCOMMENT THIS SECTION LATER
       # ### download and unzip dataset, cwd to
        #fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"        
        #download.file(fileURL, "getdata_projectfiles_UCI HAR Dataset.zip", method="curl") # download zipfile to current working directory
        #unzip("getdata_projectfiles_UCI HAR Dataset.zip") # unzip all files
        #setwd("UCI HAR Dataset")
        #message("Moving to UCI HAR directory")
}
    # that was a lot of work just to ensure that others can use this script to get to run without manual intervention :(

# 2. read data
    # just define this manually ahead of time
activity_levels <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
column_labels <- read.table("features.txt", colClasses="character")[,2] # second column of file contains variable names
#print(head(column_labels))
### train
setwd("train")
traindata <- read.table("X_train.txt", col.names=column_labels)
#print(c("training data:", dim(traindata))) # just a sanity check to see what we got, and debug progress
subjnum <- read.table("subject_train.txt", col.names="Subject")
activity <- as.factor(read.table("y_train.txt", col.names="Activity")[,1])
levels(activity) <- activity_levels
#print(head(activity))
complete_train <- cbind(activity, subjnum, traindata)
#print(c("all:", dim(complete_train)))
### test
setwd("../test")
testdata <- read.table("X_test.txt", col.names=column_labels)
#print(c("testing data:", dim(testdata))) # just a sanity check to see what we got, and debug progress
subjnum <- read.table("subject_test.txt", col.names="Subject")

# 2.5. merge in activity names
activity <- as.factor(read.table("y_test.txt", col.names="Activity")[,1])
levels(activity) <- activity_levels
#print(head(activity))
complete_test <- cbind(activity, subjnum, testdata)
#print(c("all:", dim(complete_test)))
setwd("..") # go back to main UCI HAR directory first

# 3. merge test/train
bighuge <- rbind(complete_train, complete_test)
# eliminate columns we don't care about
just_these <- grep("mean\\(\\)|std\\(\\)", column_labels) # grep gives numeric indices, grepl gives logical
just_these <- just_these + 2 # need to shift all column indices over by one because Activity and Subject column labels in first 2 columns
just_these <- c(1, 2, just_these) # above we added a column for Activity in the big data tables

# 4. extract only std/mean features to new data frame

filtered_data <- bighuge[,just_these]
print(dim(filtered_data))

# 6. create table: subject x activity = mean
output_table <- aggregate(. ~ activity + Subject, data=filtered_data, mean)

setwd("/Users/kingsbury/Data Science R files") # go back to working directory, or else we'll keep downloading the data file over and over
