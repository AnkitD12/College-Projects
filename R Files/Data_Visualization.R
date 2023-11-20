setwd("C:/Users/lenovo/OneDrive/Desktop/R Files")
#install.packages("ggplot2") #Once installed, the package will be in the setup and you need not run this command every time. 
library(ggplot2) #You need to run this command to load ggplot2 package in the current workspace. 
#?ggplot2 # This command allows you to get help about the package
library(dplyr) # package for data manipulation in R
################### Data Visualization using GGPLOT2 #####

####### Basic Scatter and Line Plots #######

mpg # data about cars
str(mpg) # structure of the dataset

ggplot(mpg) + aes(x = displ, y = hwy) + geom_point() + geom_smooth() # basic scatter plot with points and a line fitted

ggplot(mpg) + aes(x = displ, y = hwy) + geom_point(aes(color = class)) + geom_smooth() # the first aes mapping contains global mapping for aesthetic attributes, aes mapping within geom_point additionally extends the aesthetic attributes by additionally having a map for the attribute of color. 

ggplot(mpg) + aes(x = displ, y = hwy, color = class) + geom_point() + geom_smooth() # the specification of color mapping in the global aes mapping virtually subsets the data based on class. line objects of geom_smooth will now correspond to each such subset. Therefore you see lines being fitted over points corresponding to each class. 

ggplot(mpg) + aes(x = displ, y = hwy) + geom_point(aes(color=drv)) + geom_smooth() + facet_wrap(~class, nrow=2) # have separate scatter plots for each data subsetted on the basis of class attribute. 

ggplot(mpg) + aes(x = displ, y = hwy) + geom_point() + geom_smooth() + facet_grid(drv~class) # have separate scatter plots for each data subsetted on the basis of two different categorical attributes - class, and drv; arranged in a grid fashion.

ggplot(mpg) + aes(x = displ, y = hwy) + geom_point(aes(color=drv)) + geom_smooth(aes(linetype = drv)) # Not every aesthetic works with every geom. shape may not work for geom_smooth, for example. 

ggplot(mpg) + aes(x = displ, y = hwy) + geom_point(aes(color=drv)) + geom_smooth(data = filter(mpg, class == 'subcompact')) # Each geom can work with different subsets of data as well.

##### Bar Chart ##################
diamonds

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))  # instantiating a bar geometric object. Useful to visualize distribution of a categorical variable. 

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..count..)) # geom_bar computes some stats. count is the default. This command illustrates its explicit usage. 

ggplot(data = diamonds) + geom_histogram(mapping =aes(x=price),bins = 300 ) #

ggplot(data = diamonds) + geom_density(mapping =aes(x=price)) #plots the probability density function

ggplot(data= diamonds) + geom_freqpoly(mapping= aes(x=price), binwidth = 1000) #joins the top of bars in the corresponding histogram

ggplot(data= diamonds %>% filter(carat<3)) + geom_density(mapping= aes(x=carat , color = cut), binwidth = 0.1) #plot histograms separately for each class (cut) in same plot.

ggplot(data= diamonds %>% filter(carat<3)) + geom_bar(mapping= aes(x=carat , fill = clarity), position = "fill") #if our interest is only to look at distribution of one categorical variable(clarity) within the other (cut)


ggplot(data = mpg) +geom_boxplot(mapping = aes(x =class, y = hwy)) + coord_flip()
