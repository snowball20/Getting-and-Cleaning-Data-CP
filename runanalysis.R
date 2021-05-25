 if(!file.exists("./data")){dir.create("./data")}
 fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
 unzip(zipfile="./data/Dataset.zip",exdir="./data")
 path <- file.path("./data" , "UCI HAR Dataset")
 files<-list.files(path, recursive=TRUE)
 files
 ytrain<- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
 ytest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
 xtest <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
 xtrain<- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
 SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
 SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
#Merges the training and the test sets to create one data set.
  subject<-rbind(SubjectTest,SubjectTrain)
 y<-rbind(ytest,ytrain)
 x<-rbind(xtest,xtrain)
 subject<-rbind(SubjectTest,SubjectTrain)
 names(subject)<-c("subject")
 names(y)<- c("activity")
 features <- read.table(file.path(path, "features.txt"),head=FALSE)
 names(x)<- features$V2
 Combine <- cbind(subject, y)
 Data <- cbind(x, Combine)
#Extracts only the measurements on the mean and standard deviation for each measurement. 
 subFeatures<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
#Uses descriptive activity names to name the activities in the data set
 selected<-c(as.character(subFeatures), "subject", "activity" )
 Data<-subset(Data,select=selected)
 str(Data)
 activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
 head(Data$activity,30)
#Appropriately labels the data set with descriptive variable names. 
 names(Data)<-gsub("^t", "time", names(Data))
 names(Data)<-gsub("^f", "frequency", names(Data))
 names(Data)<-gsub("Acc", "Accelerometer", names(Data))
 names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
 names(Data)<-gsub("Mag", "Magnitude", names(Data))
 names(Data)<-gsub("BodyBody", "Body", names(Data))
 names(Data)
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 library(plyr);
 Dataagg<-aggregate(. ~subject + activity, Data, mean)
 Dataagg<-Dataagg[order(Dataagg$subject,Dataagg$activity),]
 write.table(Dataagg, file = "tidydata.txt",row.name=FALSE)
 