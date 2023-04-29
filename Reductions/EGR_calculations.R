###
### R-script to calculate basic descriptive statistics of tree-ring width series for each site ###
###

# Reguired open-source packages:
library(dplR);library(readxl); library(base); library(pointRes)
# Reguired input files
# Site tree-ring width series in *.rwl format
# Site metadata

############################

SITE <- read.csv("meta_github.csv")

# Dataframes to store the  results
parametry <- data.frame(siteco = SITE$site_code, a = NA, r = NA, negative.spline = NA, replication.less.5 = NA, shorter.than.40 = NA)
reccinterval <- data.frame(siteco = SITE$site_code, z40 = NA)

# Here define a spline length to be used for detrending of individual tree-ring width series
nrs.for.spline <- 30 

counter <- 1

for (i in c(1:nrow(SITE))){
  
serie1 <- read.rwl(SITE[i, "raw_data_file_name"]) 

# Each series is fit with a spline with a length equal to nrs.for.spline and trees with negative value of spline function are removed
zaporny.spline <- data.frame(SERIE = colnames(serie1), FLAG = NA)

for (j in c(1:ncol(serie1))){
  spline.fit <- ffcsaps(na.omit(serie1[,j]), nyrs = nrs.for.spline) # spline fit
  zaporny.spline[j, "FLAG"] <- sum(spline.fit < 0) # Number of years with value of spline<0
  rm(spline.fit)
}

zachovat <- unique(zaporny.spline[zaporny.spline$FLAG == 0, "SERIE"]) # List series with no tree-ring with spline<0
serie1.subset <- serie1[, colnames(serie1) %in% zachovat]

parametry[counter, "negative.spline"] <- sum(zaporny.spline$FLAG > 1)/nrow(zaporny.spline) # Proportion of series excluded due to negative spline

########

serie2 <- detrend (serie1.subset, method = "Spline", nyrs = nrs.for.spline) # Detrending tree-ring width series
serie3 <- pointer.zchron (serie2, z.thresh = 0.01, make.plot = FALSE,
                          period = c(max(1870,min(as.numeric(rownames(serie2)))), # The calculation of z-chron chronology considers only the period after 1870
                                     max(as.numeric(rownames(serie2)))))
serie4 <- serie3$out
numrows1 <- nrow(serie4)

if (max(serie4$nb.series) < 5) {parametry[counter, "replication.less.5"] <- 1} # If the replication (after the removal of series with negative spline) is lower than 5, the process is stoped
if (max(serie4$nb.series) >= 5) { 
  
  parametry[counter, "replication.less.5"] <- 0
  
  # Entire file with simulated z-chron chronology (serie5a) #
  serie5a <- subset(serie4, nb.series>=5) # Cut-off the part of chronology with replication below 5 trees
  serie5a$egrz <- serie5a$AVGztrans *-1
  
  # Subset of z-chron chronology including only negative pointers (serie5) # 
  serie5 <- subset(serie4, nb.series>=5 & AVGztrans<0) # Cut-off the part of chronology with replication below 5 trees + filter only NEGATIVE pointers
  serie5$egrz <- serie5$AVGztrans *-1
  serie5$rankz <- rank(serie5$egrz, ties.method="min") # Assign a ranking to each of negative pointers (according to their intensity)
  
  numrows2 <- nrow(serie5)
  serie5$rankevent <- numrows2+1-serie5$rankz # Inverting the ranking of negative pointers (i.e., the biggest event = 1, the second biggest event = 2, ... )
  serie5$reccevent <- numrows1/serie5$rankevent # Calculating recurence interval, i.e., how frequently did the given pointer on average occurred (the biggest event occured once per lifespan of chronology, the second biggest event occurence on average once per half of the lifespan of chronology, ...)
  fitserie <- nls(reccevent ~ a*exp(r*egrz), start = list(a=1, r=2), data = serie5, control = list(maxiter = 10000)) # Exponential regression between recurrence interval ~ pointer intensity
  parametry[counter, "a"] <- (coef(fitserie)) ["a"] # coefficients
  parametry[counter, "r"] <- (coef(fitserie)) ["r"] 
  reccinterval[counter, "z40"] <- (log(40/parametry[counter,"a"]))/parametry[counter, "r"] # Predicted value of growth reduction intensity (ERGZ) for an event with theoretical reccurence interval of 40 years based on the equation of exponential regression

  # Plot of the regression Recurrence ~ ERGZ for given site
  # Not needed to run
  # plot(serie5$reccevent ~ serie5$rankevent, col = "blue", main = paste(SITE[i, "site_name"]))
  # points(predict(fitserie) ~ serie5$rankevent, col = "red")
  # abline(a = 40, b = 0)

  serie5$zfit <- predict(fitserie)
  serie5$zz40 <- ifelse(serie5$egrz>=reccinterval[counter, "z40"], 1,0) # Which years experienced EGR, i.e., growth below theoretical threshold for events with 40-years recurrence period?
  
  if(sum(serie5$zz40) == 0){parametry[counter, "shorter.than.40"] <- 1} # Stop for series shorter than 40 years
  if(sum(serie5$zz40) > 0){ 
    parametry[counter, "shorter.than.40"] <- 0
    
    zoutput <- subset(serie5, zz40==1) # Subset of EGRs
    zoutput <- zoutput[-c(2:4,6:9)]

    # Legacy effects
    # If 2-5 EGRs occurr in a sequence, they are aggregated and assigned to the first year of the EGR period
    # In other words, we expect that the first year triggered the growth reduction, that lasted due to legacy effects for more than one growing season
    # Not needed to run
    
    zoutput$merge <- zoutput$year

    if (nrow(zoutput) > 2){
      for (j in c(2:nrow(zoutput))){
        if (zoutput[j, "year"] == (zoutput[(j-1), "year"] + 1)){zoutput[j, "merge"] <- zoutput[(j-1), "merge"]}
        if (j > 2 && zoutput[j, "year"] == (zoutput[(j-2), "year"] + 1)){zoutput[j, "merge"] <- zoutput[(j-2), "merge"]}
        if (j > 3 && zoutput[j, "year"] == (zoutput[(j-3), "year"] + 1)){zoutput[j, "merge"] <- zoutput[(j-3), "merge"]}
        if (j > 4 && zoutput[j, "year"] == (zoutput[(j-4), "year"] + 1)){zoutput[j, "merge"] <- zoutput[(j-4), "merge"]}
        if (j > 5 && zoutput[j, "year"] == (zoutput[(j-5), "year"] + 1)){zoutput[j, "merge"] <- zoutput[(j-5), "merge"]}
      }
    }
    zoutput.2 <- aggregate(zoutput[,c("egrz", "zz40")], by = list(START.YEAR = zoutput$merge), FUN = sum)
    
    colnames(zoutput.2) <- c("START.YEAR", "ERGZ", "DURATION")
    zoutput.2$SITE <- paste(SITE[i, "site_code"])
    zoutput.2$lat <- paste(SITE[i, "site_lat"])
    zoutput.2$long <- paste(SITE[i, "site_long"])
    zoutput.2$elev <- paste(SITE[i, "elevation"])
    zoutput.2$spec <- paste(SITE[i, "species"])
    write.csv(zoutput.2, paste(SITE[i, "site_code"],"ergz.csv", sep = "")) # Saving the dataframe with the list of significant EGRs for given site
  }
  
  serie5$SITE <- paste(SITE[i, "site_code"])
  serie5a$SITE <- paste(SITE[i, "site_code"])
  serie5$lat <- paste(SITE[i, "site_lat"])
  serie5a$lat <- paste(SITE[i, "site_lat"])
  serie5$long <- paste(SITE[i, "site_long"])
  serie5a$long <- paste(SITE[i, "site_long"])
  serie5$elev <- paste(SITE[i, "elevation"])
  serie5a$elev <- paste(SITE[i, "elevation"])
  serie5$spec <- paste(SITE[i, "species"])
  serie5a$spec <- paste(SITE[i, "species"])

  write.csv(serie5, paste(SITE[i, "site_code"],"bla.csv", sep = "")) # Saving a subset of z-chron chronology with only negative growth deviations for given site
  write.csv(serie5a, paste(SITE[i, "site_code"],"blall.csv", sep = "")) # Saving a full z-chron chronology for given site
  
  rm(serie1,serie1.subset, serie2, serie3, serie4, serie5, numrows2, numrows1, fitserie, zoutput, zoutput.2,
     zaporny.spline, zachovat)
}
  counter<- counter+1
  
}

write.csv(parametry, "parametry_fit_exponetnial.csv") # Saving parameters of exponential functions for all sites
