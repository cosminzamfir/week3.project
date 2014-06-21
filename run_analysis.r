## merge test/train data sets into one data set
## extract mean() and std() columns
## add descriptive activity labels
## add descriptive variable names
## export the data set to 'tidy_data_set.csv' file in the current directory
createTidyData <- function() {
  xSet <- mergeDataSets()
  xSet <- addColumns(extractColumns(xSet))
  export(xSet)
  xSet
}

## merge the test/train data sets into one data set
## the data frame containing the raw data of both data sets
mergeDataSets <- function() {
  xTrainSet <- read.csv("train/X_train.txt", sep="", header=FALSE);
  xTestSet <- read.csv("test/X_test.txt", sep="", header=FALSE);
  xSet <- rbind(xTrainSet, xTestSet)
  xSet
}


## extract the mean and standard deviation columns from the given data fram
## the relevant columns are given by matching values of the 'features' set
## param xSet - the data frame from the mergeDataSets() function
extractColumns <- function(xSet) {
  #read the variables names
  features <- read.csv("features.txt", sep="", header=FALSE);
  colnames(features) <- c("index","name");
  
  #set proper column names for the xSet
  colnames(xSet) <- features$name;
  
  #create the data set projection containing the relevant variables
  names = as.character(features$name);
  relevantNames = names[grep(".*mean().*|.*std().*", names)]
  xSet[,names(xSet) %in% relevantNames]
}


## add 'activity.id', 'activity.name' and 'subject' columns to the given data set
## the function requires 'plyr' package
## param xSet - the data frame returned by the extractColumns() function
addColumns <- function(xSet) {
  
  #add the 'subject' column stored in the subject_train and subject_test files
  subjectsTrain <- read.csv("train/subject_train.txt",sep="",header=FALSE)
  subjectsTest <- read.csv("test/subject_test.txt", sep="", header=FALSE)
  subjects <- rbind(subjectsTrain,subjectsTest)
  xSet <- cbind(subjects,xSet)
  colnames(xSet)[1] <- "subject"
  
  #add the 'activity.id' column stored in the y_train and x_train files
  yTrain <- read.csv("train/y_train.txt", sep="", header=FALSE)
  yTest <- read.csv("test/y_test.txt", sep="", header=FALSE)
  ySet <- rbind(yTrain, yTest)
  xSet <- cbind(ySet,xSet)
  colnames(xSet)[1] <- "activity.id"
  
  #join with activity labels to have descriptive activity names
  activityLabels <- read.csv("activity_labels.txt", sep="", header=FALSE)
  colnames(activityLabels) <- c("activity.id", "activity.name")
  
  library(plyr)
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

