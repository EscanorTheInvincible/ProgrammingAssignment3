library(dplyr)

# read training and testing data
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/Y_train.txt")
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/Y_test.txt")
sub_train <- read.table("./train/subject_train.txt")
sub_test <- read.table("./test/subject_test.txt")

# read features
feature_names <- read.table("./features.txt")

# read activity labels
activity_labels <- read.table("./activity_labels.txt")

# Merges the training and testing sets.
x_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)
sub_total <- rbind(sub_train, sub_test)

# Selective extracts only the measurements on the mean and standard deviation.
selected_features <- feature_names[grep("mean\\(\\)|std\\(\\)",feature_names[,2]),]
x_total <- x_total[,selected_features[,1]]

# Descriptive activity names to name the activities in the data set
colnames(y_total) <- "activity"
y_total$activitylabel <- factor(y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_total[,-1]

# Appropriately labels the data set with descriptive variable names.
colnames(x_total) <- feature_names[selected_features[,1],2]

# Creating tidy data with average feature for each activity and subject
colnames(sub_total) <- "subject"
total <- cbind(x_total, activitylabel, sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
