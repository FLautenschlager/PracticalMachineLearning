<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Assignment</title>
        <style media="screen">
          code{
            background-color: lightyellow
          }
        </style>
    </head>
    <body>
        <h1>
            Model explanation
        </h1>

        Looking at the data I saw that there was a lot of missing data. After splitting the data into a training, a testing and a validation set for cross validation with random sampling, I excluded all predictors which have NA in them. Further for the prediction, it is not important, how the person is called, or at what time he did the exercise. Also the infinite values in some predictors are not advantageous. I ruled these out using the is.numeric() function of R.
        <br>
        Afterwards I computed the correlation and found out, that a lot of the predictors are correlating:
        <ul> Correlating predictors:
          <li>"roll_belt", "yaw_belt", "total_accel_belt", "accel_belt_y", "accel_belt_z" </li>
          <li>"pitch_belt", "accel_belt_x", "magnet_belt_x"</li>
          <li>"gyros_arm_x", "gyros_arm_y"</li>
          <li>"accel_arm_x", "magnet_arm_x"</li>
          <li>"magnet_arm_y", "magnet_arm_z"</li>
          <li>"pitch_dumbbell", "accel_dumbbell_x"</li>
          <li>"yaw_dumbbell", "accell_dumbbell_z"</li>
        </ul>
        So I did a principal component analysis to get finally 46 predictors out of 56 before principal component analysis.
        <br>
        With these 46 predictors I fitted a random forest model, which reached an in-sample accuracy of 1 and an out-of-sample accuracy of 0.9912.
        The testing subset was used to choose the best model for the data, which was random forest. I also tried several other methods like decision tree or several boosting algorithms. The validation subset was used to estimate the out-of-sample accuracy.
        
        
        <h1>R markdown</h1>
        <code><ol>
        <li>    library(caret) <br></li> 
            <br>
            # read data:
        <li>     dat = read.csv("~/Desktop/pml-training.csv")</li> 
            <br>
            <br>
            <br># Split data:
        <li>     inTrain<-createDataPartition(dat$classe, p=0.7,list=FALSE)</li> 
            <br>
        <li>     training <- dat[ inTrain,]</li> 
        <li>     newdat<-dat[-inTrain,]</li> 
            <br>
        <li>     inTrain<-createDataPartition(newdat$classe, p=0.5,list=FALSE)</li> 
        <li>     testing<- newdat[ inTrain,]</li> 
        <li>     validation<-newdat[ -inTrain,]</li> 
            <br>
            <br>
            <br>
            <br># Remove NA-predictors
        <li>     a<-which(is.na(training[1,])==TRUE)</li> 
        <li>     newtrain<-training[,-a]</li> 
            <br>
            <br>
            <br># Remove inf-predictors, name and Date
        <li>     b<-numeric()</li> 
        <li>     for (i in 1:(dim(newtrain)[2]-1)){</li> 
        <li>     if (is.numeric(newtrain[,i])==FALSE) b[i]<-i}</li> 
        <li>     b2<-b[-which(is.na(b))]</li> 
        <li>     newtrain<-newtrain[,-b2]</li> 
            <br>
            <br>
            <br># Correlation Matrix
        <li>     M<-abs(cor(newtrain[,-(dim(newtrain)[2])]))</li> 
        <li>     diag(M)<-0</li> 
        <li>     which(M>0.8,arr.ind=T)</li> 
            <br>
            <br># PCA preprocessing
        <li>     preproc<-preProcess(newtrain[,-57],method="pca", pcaComp=46)</li> 
        <li>     trainPC=predict(preproc, newtrain[,-57])</li> 
            <br>
            <br># train RF-model
        <li>     modFit<-train(newtrain$classe ~., method="rf", data=trainPC)</li> 
            <br>
            <br># Checking Accuracy
        <li>     confusionMatrix(training$classe, predict(modFit,trainPC))</li> 
            <br>
            <br># cross-validation with testing and validation set:
            <br>
            <br># Data selection
        <li>     testing<-(testing[,-a])[,-b2]</li> 
            <br># PCA
        <li>     testPC<-predict(preproc,testing[,-57])</li> 
            <br># Checking accuracy
        <li>     confusionMatrix(testing$classe, predict(modFit,testPC))</li> 
            <br>
            <br># Data selection
        <li>     validation2<-(validation[,-a])[,-b2]</li> 
            <br># PCA
        <li>     valPC<-predict(preproc,validation2[,-57])</li> 
            <br># Out of sample accuray:
        <li>     confusionMatrix(validation$classe, predict(modFit,valPC))</li> 
            <br>
            <br>
            <br># predicting the pml-testing.csv-data
        <li>     testing = read.csv("~/Desktop/pml-testing.csv")</li> 
            <br>
            <br># Data selection
        <li>     testing<-(testing[,-a])[,-b2]</li> 
            <br># PCA
        <li>     testPC<-predict(preproc,testing[,-57])</li> 
            <br># Prediction
        <li>     pred<-predict(modFit,testPC)</li> 
            </ol></code>
    </body>
    
</html>
