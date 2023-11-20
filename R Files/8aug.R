setwd("C:/Users/lenovo/OneDrive/Desktop/R Files")
#install.packages("ggplot2") #Once Installed, the package will be in the setup and you need not to run this command every time
library(ggplot2) #You need to run this command to load ggplot2 package in the current workspace
mpg
?ggplot2 #This command allows you to help about the package description

#Explore data set MPG
#Understand the relationship b/w fuel efficiency and Engine cc.
ggplot(data=mpg)+ geom_point(mapping = aes(x=displ,y =hwy)) + geom_smooth(mapping=aes(x=displ, y=hwy))
