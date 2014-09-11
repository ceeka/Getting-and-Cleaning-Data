training <- read.csv("UCI HAR Dataset/train/X_train.txt",sep = "",header = FALSE)
training[,562] <- read.csv("UCI HAR Dataset/train/y_train.txt",sep = "",header = FALSE)
training[,563] <- read.csv("UCI HAR Dataset/train/subject_train.txt",sep = "",header = FALSE)


testing <- read.csv("UCI HAR Dataset/test/X_test.txt",sep = "",header = FALSE)
testing[,562] <- read.csv("UCI HAR Dataset/test/y_test.txt",sep = "",header = FALSE)
testing[,563] <- read.csv("UCI HAR Dataset/test/subject_test.txt",sep = "",header = FALSE)

collection <- rbind(training,testing)

features<- read.csv("UCI HAR Dataset/features.txt",sep = "",header = FALSE)
features[,2] <- gsub("-mean","Mean",features[,2])
features[,2] <- gsub("-std","Std",features[,2])
features[,2] <- gsub("[-()]","",features[,2])


reqdcol <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[reqdcol,]

reqdcol <- c(reqdcol,562,563)

collection <- collection[,reqdcol]
colnames(collection)<- c(features$V2,"Activity","Subject")
colnames(collection)<- tolower(colnames(collection))

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  collection$activity <- gsub(currentActivity, currentActivityLabel, collection$activity)
  currentActivity <- currentActivity + 1
}


collection$activity <- as.factor(collection$activity)
collection$subject <- as.factor(collection$subject)

tidy = aggregate(collection, by=list(activity = collection$activity, subject=collection$subject), mean)
# Remove the subject and activity column, since a mean of those has no use
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")