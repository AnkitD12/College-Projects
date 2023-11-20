install.packages("readxl")
install.packages("ggplot2")
library(readxl)
library(ggplot2)

data <- read_excel("C:/Users/lenovo/Downloads/IPL IMB381IPL2013.xlsx", sheet = "IPL IMB381IPL2013")
data

plot(x=data$`SOLD PRICE` , y =data$AVE)

scatter_plot <- ggplot(data, aes(x = data$`SOLD PRICE`, y = data$AVE)) +
  geom_point() +
  labs(title = "Scatter Plot: Sold Price Vs Average",
       x = "Sold Price",
       y = "Average")

print(scatter_plot)

scatter_plot_with_regression <- scatter_plot + geom_smooth(method = "lm", se = FALSE)

print(scatter_plot_with_regression)


