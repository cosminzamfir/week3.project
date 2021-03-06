1. Input data:
  - 'features_info.txt': Shows information about the variables used on the feature vector.
  - 'features.txt': List of all features.
  - 'activity_labels.txt': Links the class labels with their activity name.
  - 'train/X_train.txt': Training set.
  - 'train/y_train.txt': Training labels.
  - 'test/X_test.txt': Test set.
  - 'test/y_test.txt': Test labels.
  - 'train/subject_train.txt': The subjects for the train set
  - 'test/subject_test.txt': The subjects for the test set
  
2. Variables: the following variables are avaialble in the data set:

 - tBodyAcc-XYZ
 - tGravityAcc-XYZ
 - tBodyAccJerk-XYZ
 - tBodyGyro-XYZ
 - tBodyGyroJerk-XYZ
 - tBodyAccMag
 - tGravityAccMag
 - tBodyAccJerkMag
 - tBodyGyroMag
 - tBodyGyroJerkMag
 - fBodyAcc-XYZ
 - fBodyAccJerk-XYZ
 - fBodyGyro-XYZ
 - fBodyAccMag
 - fBodyAccJerkMag
 - fBodyGyroMag
 - fBodyGyroJerkMag

- '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
- for each variable (and each direction for 3-axial variables) the mean and standard deviation for the sampling window are provided.
- the naming of the columns follow the pattern: variableName-[mean()|std()]-[X|Y|Z]. Example: mean of tBodyAcc for X axis is named tBodyAcc-mean()-X

3. Data transformation - implemented by run_analysis.R
  - merge 'train/X_train.txt' and 'test/X_test.txt' into one data frame - function mergeDataSets()
  - set the variable names in features.txt as colnames for the above data frame; extract only the mean() and std() columns
  from the data frame - function extractRelevantColumns()
  - add 'subject' column to the data frame with values from 'train/subject_train.txt' and 'test/subject_test.txt'; 
  add 'activity_id' column to the data frame with values from 'train/y_train.txt' and 'test/y_test.txt';
  add the 'activity.label' to the data frame by merging the data frame with the labels stored in activity_labels.txt -   function  addIdentifierColumns()
  - compute the mean of each variable in the data frame for each activiy/subject combination - function aggregateByActivitySubject()
  
4. Result
  - one data frame containing the mean() and std() combined observations from 'X_train.txt' and 'Y_train.txt' with descriptive variable names and descriptive identifier columns
  - 'tidy_data_set.csv' - data frame above exported as csv file
  - one data frame containing the mean of each variable in the 'tidy data set' for each activiy/subject combination
