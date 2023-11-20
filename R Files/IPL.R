########################################################
rm(list=ls())
library(car)
install.packages("tidyverse")
library(tidyverse)  # data manipulation and visualization
#library(modelr)     # provides easy pipeline modeling functions
library(broom)      # converts messy output from lm , nls

data1<-read.table(file="C:/Users/lenovo/Downloads/IPL IMB381IPL2013.csv",header=TRUE,sep=",")
dat1<-data1[,-c(1:5)] # Excluded 
attach(dat1)
names(dat1)

dummies<- data.frame(sapply(dat1, function(x) data.frame(model.matrix(~x-1,data =dat1))[,-1]))

out1<-cbind(dat1[,2:21],dummies)

#out2<-out1[out1$PLAYING.ROLE.xBowler!=1,]
#Divide the data set into two: 75% train, 25% test
smp_size <- floor(0.75 * nrow(out1)) 
## set the seed to make your partition reproducible
set.seed(123)
train.ind <- sample(1:nrow(out1), size = smp_size)
out <- out1[train.ind, ]
test_out <- out1[-train.ind, ]

# Scatter Plot
ggplot(out, aes(x = ODI.SR.B, y = SOLD.PRICE)) +
  geom_point()+
  geom_smooth(method = lm, se = FALSE)+
  theme_classic()
ggplot(out, aes(x = SIXERS, y = SOLD.PRICE)) +
  geom_point()+
  geom_smooth(method = lm, se = FALSE)+
  theme_classic()

library(psych)
pairs.panels(out, 
             method = "pearson", # correlation method
             density = FALSE,  # do not show density plots
             ellipses = FALSE # show correlation ellipses
)

lm1 <- lm(SOLD.PRICE~ ODI.SR.B, data = out)
summary(lm1)
#step(lm_total, direction = "backward")

lm2 <- lm(formula = SOLD.PRICE ~ ODI.SR.B + SIXERS, data = out)
summary(lm2)

lm_total <- lm(SOLD.PRICE~., data = out)
summary(lm_total)

lm_step<-step(lm_total, direction = "backward")
summary(lm_step)

lm_total <- lm(SOLD.PRICE ~ ODI.RUNS.S+ODI.WKTS + ODI.SR.BL + 
RUNS.S + HS + RUNS.C + AUCTION.YEAR + BASE.PRICE + PLAYING.ROLE.xBowler + 
PLAYING.ROLE.xW..Keeper, data = out)
summary(lm_total)

lm_step<-step(lm_total, direction = "backward")
summary(lm_step)
# Model diagnostic

# Homogeneity assumption
plot(fitted(lm_step), resid(lm_step),ylab="Residuals", xlab="Fitted Values", main="Residual Plot")
abline(0,0)

#Normality
qqnorm(resid(lm_step))
qqline(resid(lm_step))

# Influence measures
summary(influence.measures(lm_step))  

# Multicollinearity
install.packages("vif")
library(vif)
vif(lm_step)

# Prediction
predictions_All <- predict(lmstep, newdata = test_out, type = "response")
head(predictions_All)

mean(predictions_All-test_out$SOLD.PRICE)^2
