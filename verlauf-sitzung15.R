?cars
head(cars)
library(ggplot2)
ggplot(cars,aes(x=speed,y=dist)) + geom_point()
cars.lm <- lm(dist ~  speed, data=speed)
cars.lm <- lm(dist ~  speed, data=cars)
cars.lm
ggplot(cars,aes(x=speed,y=dist)) + geom_point() + scale_x_continuous(limits=c(0,25))
ggplot(cars,aes(x=speed,y=dist)) + geom_point() + scale_x_continuous(limits=c(0,25)) + geom_smooth(method="lm")
summary(cars.lm)
ggplot(cars,aes(x=speed,y=dist)) + geom_point() + scale_x_continuous(limits=c(0,25)) + geom_smooth(method="loess")
ggplot(cars,aes(x=speed,y=dist)) + geom_point() + scale_x_continuous(limits=c(0,25)) + geom_smooth(method="lm")
ggplot(cars,aes(x=speed^2,y=dist)) + geom_point() + scale_x_continuous(limits=c(0,25)) + geom_smooth(method="lm")
ggplot(cars,aes(x=speed**2,y=dist)) + geom_point() + scale_x_continuous(limits=c(0,25)) + geom_smooth(method="lm")
ggplot(cars,aes(x=(speed**2),y=dist)) + geom_point() + scale_x_continuous(limits=c(0,25)) + geom_smooth(method="lm")
ggplot(cars,aes(x=speed,y=dist)) + geom_point() + scale_x_continuous(limits=c(0,25)) + geom_smooth(method="lm")
cars2 <- cars
cars2$speed2 <- cars2$speed^2
head(cars2)
ggplot(cars2,aes(x=speed2,y=dist)) + geom_point() + scale_x_continuous(limits=c(0,25)) + geom_smooth(method="lm")
ggplot(cars2,aes(x=speed2,y=dist)) + geom_point() + geom_smooth(method="lm")
cars.lm2 <- lm(dist ~ speed2, data=cars)
cars.lm2 <- lm(dist ~ speed2, data=cars2)
summar(cars.lm2)
summary(cars.lm2)
summary(cars.lm)
savehistory("~/Statistik-f-r-Sprachwissenschaftler/verlauf-sitzung15.R")
