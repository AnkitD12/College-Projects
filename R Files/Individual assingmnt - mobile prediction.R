library(tidyverse)
library(ggplot2)
#install.packages("rpart")
library(rpart)
#install.packages("rpart.plot")
library(rpart.plot)
#install.packages("rattle")
library(rattle)
#install.packages("tree")
library(tree)
library('class')
library(corrplot)
library(RColorBrewer)
#install.packages("e1071")
library(e1071)
#install.packages("plotly")
library(plotly)
#install.packages("rsample")
library(rsample)
install.packages("naivebayes")
library(naivebayes)

df <- read.csv("C:/Users/lenovo/OneDrive/Desktop/R Files/train.csv")

df.split <- rsample::initial_split(
  df,
  prop=0.75, # 75% training, 25% testing 
  strata=price_range)

df.train <- rsample::training(df.split)
df.test <- rsample::testing(df.split)


head(df.train)

dim(df.train)

summary(df.train)

# DISTRIBUTION OF CAMERA QUALITY
data = data.frame(MegaPixels = c(df$fc, df$pc), 
                  Camera = rep(c("Front Camera", "Primary Camera"), 
                               c(length(df$fc), length(df$pc))))
ggplot(data, aes(MegaPixels, fill = Camera)) + 
  geom_bar(position = 'identity', alpha = .5)



df.train = na.omit(df.train)
df.test = na.omit(df.test)


duplicated(df.train)
duplicated(df.test)


cor(df.train)


corrplot(cor(df.train), type='upper', order='hclust', col=brewer.pal(n=8, name="RdYlBu"))


ggplot(data = df.train, mapping=aes(x=ram, y=price_range)) +
  geom_smooth(se=FALSE, color='darkgreen', method='gam', formula = y ~ s(x, bs = "cs")) + 
  ggtitle('Ram v. Price Range: +90% correlation') +
  theme(plot.title = element_text(face="bold")) + 
  labs(x = 'Ram', y='Price Range')



ggplot(data = df.train, mapping=aes(x=battery_power, y=price_range)) +
  geom_smooth(se=FALSE, color='darkblue', method='gam', formula = y ~ s(x, bs = "cs")) +
  ggtitle('Battery Power v. Price Range: +20% correlation') +
  theme(plot.title = element_text(face="bold")) +
  labs(x = 'Battery Power', y='Price Range')

ggplot(data = df.train, mapping=aes(x=px_height, y=price_range)) +
  geom_smooth(se=FALSE, color='red', method='gam', formula = y ~ s(x, bs = "cs")) +
  ggtitle('Pixel Height v. Price Range: ~15% correlation') +
  theme(plot.title = element_text(face="bold")) +
  labs(x = 'Pixel Height', y='Price Range')

#Support Vector Machine

set.seed(1)

svm <- svm(price_range~ram+battery_power+px_height, data=df.train, cost=10)


# Root Mean Squared Error (SVM)
predict_svm_train <- predict(svm, df.train)
sqrt(mean(df.train$price_range - predict_svm_train)^2)

predict_svm_test <- predict(svm, df.test)  
sqrt(mean(df.test$price_range - predict_svm_test)^2)


# Mean Squared Error (SVM)
predict_svm_train_2 <- predict(svm, df.train)
mean(df.train$price_range - predict_svm_train_2)^2


#Linear Regression
set.seed(1)

lr.fit = lm(price_range~ram, data=df.train)
summary(lr.fit)


set.seed(1)

lr.fit2 = lm(price_range~ram+battery_power, data=df.train)
summary(lr.fit2)

set.seed(1)

lr.fit3 = lm(price_range~ram+battery_power+px_height, data=df.train)
summary(lr.fit3)

# Root Mean Squared Error (LR)
predict_lr.fit3_train <- predict(lr.fit3, df.train)
sqrt(mean(df.train$price_range - predict_lr.fit3_train)^2)

predict_lr.fit3_test <- predict(lr.fit3, df.test)  
sqrt(mean(df.test$price_range - predict_lr.fit3_test)^2)


# Mean Squared Error (LR)

predict_lr.fit3_train_2 <- predict(lr.fit3, df.train)
mean(df.train$price_range - predict_lr.fit3_train_2)^2

predict_lr.fit3_test_2 <- predict(lr.fit3, df.test)  
mean(df.test$price_range - predict_lr.fit3_test_2)^2


#Visualisng Linear Regression Model
plot(lr.fit3)





fig <- plot_ly(
  df.train,
  x=~df.train$ram,
  y=~df.train$battery_power,
  z=~df.train$px_height,
  color=predict_lr.fit3_train,
  type='scatter3d',
  mode='markers')

fig <- fig %>% layout(
  title='Ram x Battery Power x Pixel Height',
  scene=list(
    xaxis=list(title='Ram'),
    yaxis=list(title='Battery Power'),
    zaxis=list(title='Pixel Height')
  ))
fig
