## read data into R
worms <- read.csv("worms.csv", header = T)

## summarise data set
summary(worms)

## add column corresponding to area in acres
worms$Area.acres <- worms$Area * 2.47105
summary(worms$Area.acres)

## add column corresponding to worm abundance
worms$Abundance <- worms$Worm.density * worms$Area
summary(worms$Abundance)

## plot histograms for worm density and area
par(mfrow = c(1, 2)) 
hist(worms$Worm.density, main = "Histogram", xlab = "Worm Density")
hist(worms$Area, main = "Histogram", xlab = "Area")

## reset plot layout
par(mfrow = c(1, 1)) 
## box-and-whisker plot for worm density against vegetation
plot(worms$Vegetation, worms$Worm.density)

## scatter plot for worm density against area with
## fitted regression line
plot(Worm.density ~ Area, data = worms, 
     pch = 20, ylab = "Response variable", 
     xlab = "Explanatory variable")
linmod <- lm(Worm.density ~ Area, data = worms)
abline(linmod)
