#basic data
features<- read.table("./features.txt",header=F)
features<- as.character(features[,2])
activity<- read.table("./activity_labels.txt",header=F,col.names = c("activity_label","activity_name"))
#filter only mean and standard deviation measurements
filter<- grep("([Mm][Ee][Aa][Nn]|[Ss][Tt][Dd])",x = features)

#obtain test
x_test<- read.table("./test/X_test.txt",header=F)
colnames(x_test)<- features
x_test<- x_test[,filter]

#tidy test data
y_test<- read.table("./test/y_test.txt",header=F)
colnames(y_test)<- "activity_label"
test<- cbind(y_test,x_test)
subject_test<- read.table("./test/subject_test.txt",header=F)
colnames(subject_test)<-"subject"
test<- cbind(subject_test,test)

#obtain train
x_train<- read.table("./train/X_train.txt",header=F)
colnames(x_train)<- features
x_train<- x_train[,filter]

#tidy train data
y_train<- read.table("./train/y_train.txt",header=F)
colnames(y_train)<- "activity_label"
train<- cbind(y_train,x_train)
subject_train<- read.table("./train/subject_train.txt",header=F)
colnames(subject_train)<-"subject"
train<- cbind(subject_train,train)

#merge test and train
data<- rbind(test,train)

#name activities
data<- merge(data,activity,by.x = "activity_label",by.y="activity_label")
data<- subset(data,select=-activity_label)

#second data, average of each variable for each activity and each subject
library(reshape2)
data_average<- melt(data,c("activity_name","subject"),m=colnames(data)[2:87])
data_average<- dcast(data_average,activity_name+subject~variable,mean)
