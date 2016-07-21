library(caret) 

# read data:
dat = read.csv("~/Desktop/pml-training.csv")



# Split data:
inTrain<-createDataPartition(dat$classe, p=0.7,list=FALSE)

training <- dat[ inTrain,]
newdat<-dat[-inTrain,]

inTrain<-createDataPartition(newdat$classe, p=0.5,list=FALSE)
testing<- newdat[ inTrain,]
validation<-newdat[ -inTrain,]




# Remove NA-predictors
a<-which(is.na(training[1,])==TRUE)
newtrain<-training[,-a]



# Remove inf-predictors, name and Date
b<-numeric()
for (i in 1:(dim(newtrain)[2]-1)){
if (is.numeric(newtrain[,i])==FALSE) b[i]<-i}
b2<-b[-which(is.na(b))]
newtrain<-newtrain[,-b2]



# Correlation Matrix
M<-abs(cor(newtrain[,-(dim(newtrain)[2])]))
diag(M)<-0
which(M>0.8,arr.ind=T)


# PCA preprocessing
preproc<-preProcess(newtrain[,-57],method="pca", pcaComp=46)
trainPC=predict(preproc, newtrain[,-57])


# train RF-model
modFit<-train(newtrain$classe ~., method="rf", data=trainPC)


# Checking Accuracy
confusionMatrix(training$classe, predict(modFit,trainPC))


# cross-validation with testing and validation set: 

# Data selection
testing<-(testing[,-a])[,-b2]

# PCA
testPC<-predict(preproc,testing[,-57])

# Checking accuracy
confusionMatrix(testing$classe, predict(modFit,testPC))


# Data selection
validation2<-(validation[,-a])[,-b2]

# PCA
valPC<-predict(preproc,validation2[,-57])

# Out of sample accuray:
confusionMatrix(validation$classe, predict(modFit,valPC))



# predicting the pml-testing.csv-data
testing = read.csv("~/Desktop/pml-testing.csv")


# Data selection
testing<-(testing[,-a])[,-b2]

# PCA
testPC<-predict(preproc,testing[,-57])

# Prediction
pred<-predict(modFit,testPC)
