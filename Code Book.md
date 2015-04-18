# CodeBook

This is a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data.

## The data source

* Original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Original description of the dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Raw data

Their data was obtained from carrying out experiments with 30 participants performing six different activities while wearing a smartphone. The data was randomly split into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. Using the phone's embedded accelerometer and gyroscope, they captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz.  

- subject_test.txt: contains the participant number (1-30) for the test data  
- y_test.txt: contains the activity number (1-6) for the test data  
- x_test.txt: contains the vector information (1-531) for the test data  
- subject_training.txt: contains the participant number (1-30) for the training data  
- y_training.txt: contains the activity number (1-6) for the training data  
- x_trainingt.txt: contains the vector information (1-531) for the training data  
- features.txt: contains the descriptive names of activities
- activity_labels.txt : contains the labels of activities

 For more detailed information on the original data set consult the README.txt file included in the original project.
 
## Transformations details

There are the next five parts:

1) Merges the training and the test sets to create one data set.

The data and labels were loaded into R. The identifier column names were given more appropriate labels such as "activity" and "participant". The vector measurement column names were renamed according to the features text file. These names were cleaned up by removed unneccessary brackets. I found that the resultant names descriptive yet readable and succint, Ex:

	- tGravityAcc.mean.X
	- tBodyAccJerkMag.mean
	- tBodyAcc-mean-X   
	- fBodyAcc-std-Z

2) Extracts only the measurements on the mean and standard deviation for each measurement.

The next step was to create a summarising data frame that displayed only mean and standard deviation data. The test and training data sets were merged into a single data frame and then filtered by searching the column names for "std" and "mean". These filtered columns were combined with the identifier columns to create a new data frame. 

3) Uses descriptive activity names to name the activities in the data set

The numeric labels for activities were converted to descriptive ones using the map values function and activity_labels text file. They were then tidied up by changing the characters to lower case and replacing underscores with spaces which produced the following labels.

	1. walking  
	2. walking upstairs  
	3. walking downstairs  
	4. sitting  
	5. standing  
	6. laying  

4) Appropriately labels the data set with descriptive activity names.Then an independent tidy data frame was created using the aggretate function with the average of each variable for each activity and each subject. As a result of aggregating, new columns were made making some of the old ones unneccessary. The old ones were deleted and the new ones were renamed.

5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. The tidy data frame was written to a file called ```analysis.txt``` in the working directory.

### Data Dictionary

There are two diferent identifiers:

- participant - the participant number (1-30) 
- activity - the activity description

The vector information contains 81 rows that are compromised of many elements for each measurement. For example "tBodyAcc-mean-X" denotes a measurement of the mean of a person's acceleration along the x axis as calculated using time. Below are the list of parameters that appear in the tidy data set:  

- t prefix - measurement was calculated using the time domain  
- f prefix- measurement was calculated using the frequency domain
- Body - the person's own movement  
- Gravity - movement due to gravity  
- Acc - acceleration - m/s^2  
- Jerk - jerk - m/s^3  
- Gyro - angular velocity - radians/s  
- Mag - magnitude using the Euclidean norm
- std - standard deviation  
- mean - average  
- x, y, z - which axis the measurement corresponds to  
