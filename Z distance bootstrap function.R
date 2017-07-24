############################

#7/10/2017
#Ryan Fields

#Bootstrap of 95% Z distance function






rm(list = ls())
graphics.off()

#load packages
library(plyr)
library(dplyr)
library(tcltk) # for progress bar



#Set working directory
setwd('~/FCB_Lab_Projects/JoVE Publication/Analysis in R')


#load data

fishes = read.csv('Fish for Zdistance.csv') 

#check what species are present:
levels(fishes$Common.Name)


############################
############################
############################

# Define bootstrap function (dataset default set to 'fishes' above)


boot.plot = function(species, dataset = fishes){
  
  #Filter data based
  fish.data = filter(dataset, Common.Name == (species))
 
  #define sample size groups: here sample sizes 2-300 by increments of 2
  N = seq(2,300,2)
  N.len = length(N)
  
  #Define bootstrap repetitions for each sample size: here set to 1000
  R = 1000
  
  #Size of dataset (after filtering out species of interest)
  samp.size = length(fish.data[,1])
  
  #Blank dataframe to store final mean values
  fish.boot = data.frame(N,mean = NA, LL = NA, UL = NA)
  
  #Progress bar to visually track progress of bootstrap
  pb <- winProgressBar(title = "progress bar", min = 0,
                       max = N.len, width = 300)
  
  for(j in 1:N.len){
    
    #vector to store bootstrapped Z distance values
    temp.data = rep(NA, R)
    
    #progress bar#######
    setWinProgressBar(pb, j, title=paste( round(j/N.len*100, 0),
                                          "% bootstrapped"))
    # withProgress(message = 'Making plot', value = 0, {
    
    for(i in 1:R){
      rows = sample(samp.size, N[j], replace = TRUE) #pick random rows with replacement
      d = fish.data[rows,]                          # select data using these row numbers
      temp.data[i] = as.numeric(quantile(d$Z.distance, .95))  #find 95th quantile of bootstrapped data
    }
    
    #For each of R iterations store the mean value of the 95th quantile Z distance
    #As well as the 2.5th quantile and 97.5th percentile as confidence intervals
    fish.boot$mean[j] = mean(temp.data)
    fish.boot$LL[j] = quantile(temp.data, .025)
    fish.boot$UL[j] = quantile(temp.data, .975)
    
  }
  
  close(pb)
  
  #Scale plot based on values
  ymax = max(fish.boot$mean) + .15
  ymin = min(fish.boot$mean) - .15
  
  #plot results
  par(las = 1, bty = 'l', mai = c(.5,.7,.2,.15), mgp = c(2.2,.5,0), tcl = -.3)
  plot(mean ~ N, data = fish.boot, pch = 19, xlim = c(-5,300), col = rgb(0,0,0,.35),
       ylab = 'Mean 95% Z distance (m)',ylim = c(ymin, ymax), xlab = '', xaxt = 'n')
  box(lwd = 2)
  axis(side = 1, lwd = 2, mgp = c(2,.2,0))
  axis(side = 2, lwd = 1.5)
  title(xlab = 'Number of Samples', mgp = c(1.2, .5,0)) #xaxis
  
}



#example plot
boot.plot('Pygmy Rockfish')

