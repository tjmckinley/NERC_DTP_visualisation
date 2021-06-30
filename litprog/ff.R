
``{r, eval = F}
## load the data
ff <- readRDS("ff.rds")

## summarise data
summary(ff)

## plot thorax against group
plot(thorax ~ group, data = ff, 
     ylab = "Length of thorax (mm)", 
     xlab = "Experimental group")
     
## plot longevity against group
plot(longevity ~ group, data = ff,
     ylab = "Longevity (days)", 
     xlab = "Experimental group")

## plot longevity against thorax
plot(longevity ~ thorax, data = ff, 
     pch = 20, 
     xlab = "Length of thorax (mm)",
     ylab = "Longevity (days)")
``

