### Getting and cleaning Data Course Project
###  File : run_analysis.R
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 0. Check enviroment
#++++++++++++++++++++++++++++++++++++++++++++++++++++++
#**********************************************************
# Function compruebaPackage 
# Check for a package, install it otherwise and load again
#**********************************************************
compruebaPackage <- function(x) {
  if (!require(x,character.only = TRUE)) {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

# Check for package "plyr" 
compruebaPackage("plyr")

# Check if a data folder exists; if not then create one
if (!file.exists("data")) {dir.create("data")}

# Check if data file exits; if not download the and unzip file 
if (!file.exists("./dataset.zip")) {
  # file URL, destination zip file, destination data files
  URLArchivo <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  ArchivoDestino <- "./data/dataset.zip"
  
  # Download the file and note the time
  download.file(URLArchivo, ArchivoDestino)
  dateDownloaded <- date()
  
  # Unzip the data file
  unzip(ArchivoDestino, exdir = "./data/", overwrite = TRUE,)
  
  # Data set for test
  DSTest <- "./data/UCI HAR Dataset/test/X_test.txt"
  DSTestLabel <- "./data/UCI HAR Dataset/test/Y_test.txt"
  DSTestSubject <- "./data/UCI HAR Dataset/test/subject_test.txt"
  
  # Data set for training
  DSTraining <- "./data/UCI HAR Dataset/train/X_train.txt"
  DSTrainingLabel <- "./data/UCI HAR Dataset/train/Y_train.txt"
  DSTrainingSubject <- "./data/UCI HAR Dataset/train/subject_train.txt"
  
  # Data set activity labels and features
  DSActivityLabel <- "./data/UCI HAR Dataset/activity_labels.txt"
  DSFeatures <- "./data/UCI HAR Dataset/features.txt"
}

# Read Test
DSTest <- read.table(DSTest)
DSTestLabel <- read.table(DSTestLabel)
DSTestSubject <- read.table(DSTestSubject)

# Read Training
DSTraining <- read.table(DSTraining)
DSTrainingLabel <- read.table(DSTrainingLabel)
DSTrainingSubject <- read.table(DSTrainingSubject)

# Read Activity and Features
DSActivityLabel <- read.table(DSActivityLabel)
DSFeatures <- read.table(DSFeatures)

# clean up Features and Label
DSFeatures <- gsub("\\()", "", DSFeatures$V2)
DSActivityLabel <- DSActivityLabel$V2
DSActivityLabel <- tolower(DSActivityLabel)
DSActivityLabel <- sub("_", " ", DSActivityLabel)

# Rename  the columns in DSTest, DSTestLabel and DSTestSubject 
names(DSTest) <- DSFeatures
names(DSTraining) <- DSFeatures
names(DSTestLabel) <- "activity" 
names(DSTrainingLabel) <- "activity"
names(DSTestSubject) <- "participant" 
names(DSTrainingSubject) <- "participant"

#++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1.- Merges the training and the test sets to create
# one data set
#++++++++++++++++++++++++++++++++++++++++++++++++++++++
DF1 <- rbind(DSTest, DSTraining)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2.- Extracts only the measurements on the mean and 
## standard deviation for each measurement
#++++++++++++++++++++++++++++++++++++++++++++++++++++++
DFCriterios <- grep("mean|std", names(DF1))

#++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 3.- Uses descriptive activity names to name the 
## activities in the data set
#++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Create a  new DF
DFTest <- data.frame(DSTestLabel, DSTestSubject)
DFTraining <- data.frame(DSTrainingLabel, DSTrainingSubject)
DF2 <- rbind(DFTest, DFTraining)

# Add the DFCriterios column to a new DF
for (each in DFCriterios){
  DF2 <- cbind(DF2, DF1[each])
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 4.- Appropriately labels the data set with 
#descriptive variable names. 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++
DF2$activity <- mapvalues(DF2$activity, 
                             from = levels(factor(DF2$activity)), 
                             to = DSActivityLabel)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 5.- From the data set in step 4, creates a second, 
## independent tidy data set with the average of each 
## variable for each activity and each subject.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++

DFTidy <- aggregate(DF2, list(DF2$participant, DF2$activity), mean)

# Clean up the columns and column names
DFTidy$participant <- NULL
DFTidy$activity <- NULL
names(DFTidy)[1] <- "participant"
names(DFTidy)[2] <- "activity"

# Write  DFTidy into a  .txt file
write.table(file = "analysis.txt", x = DFTidy, row.names = FALSE)
