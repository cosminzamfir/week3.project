## merge test/train data sets into one data set
## extract mean() and std() columns
## add descriptive activity labels
## add descriptive variable names
## export the data set to 'tidy_data_set.csv' file in the current directory
createTidyData <- function() {
  xSet <- addIdentifierColumns(extractRelevantColumns(mergeDataSets()))
  export(xSet)
  xSet
}


## merge the test/train data sets into one data set
## return the data frame containing the raw data of both data sets
mergeDataSets <- function() {
  xTrainSet <- read.csv("train/X_train.txt", sep="", header=FALSE);
  xTestSet <- read.csv("test/X_test.txt", sep="", header=FALSE);
  xSet <- rbind(xTrainSet, xTestSet)
  xSet
}


## extract the mean and standard deviation columns from the given data frame
## the relevant columns are given by matching values of the 'features' set
## param xSet - the data frame from the mergeDataSets() function
extractRelevantColumns <- function(xSet) {
  
  #read the variables names
  names <- as.character(read.csv("features.txt", sep="", header=FALSE)$V2)
  colnames(xSet) <- names
  
  #create the data set projection containing the relevant variables
  relevantNames = names[grep("mean()|std()", names)]
  xSet[,names(xSet) %in% relevantNames]
}


## add 'activity.id', 'activity.name' and 'subject' columns to the given data set
## the function requires 'plyr' package
## param xSet - the data frame returned by the extractColumns() function
addIdentifierColumns <- function(xSet) {
  require(plyr)
  #add the 'subject' column stored in the subject_train and subject_test files
  subjects <- rbind(read.csv("train/subject_train.txt",sep="",header=FALSE),read.csv("test/subject_test.txt", sep="", header=FALSE))
  xSet <- cbind(subjects,xSet)
  colnames(xSet)[1] <- "subject"
  
  #add the 'activity.id' column stored in the y_train and x_train files
  ySet <- rbind(read.csv("train/y_train.txt", sep="", header=FALSE), read.csv("test/y_test.txt", sep="", header=FALSE))
  xSet <- cbind(ySet,xSet)
  colnames(xSet)[1] <- "activity.id"
  
  #join with activity labels to have descriptive activity names
  activityLabels <- read.csv("activity_labels.txt", sep="", header=FALSE)
  colnames(activityLabels) <- c("activity.id", "activity.name")
  
  #make sure 'activity.id' and 'activity.name' are the first columns
  xSet <- join(xSet,activityLabels)[,union(names(activityLabels), names(xSet))]
}


##export the xSet as a csv file
export <- function(xSet) {
  write.csv(xSet,"tidy_data_set.csv",quote=FALSE)
}

##compute the average of each variable by activity.name and subject
aggregateByActivitySubject <- function(xSet) {  
  aggr = aggregate(xSet[,4:82],list(Activity = xSet[,"activity.name"], Subject = xSet[,"subject"]),mean,simplify=TRUE)
}

