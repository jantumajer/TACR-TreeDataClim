###
### This is R-script to calculate basic descriptive statistics of tree-ring width series for each site ###
###

# Reguired open-source packages:
library(dplR);library(readxl); library(base); library(pointRes)
# Reguired input files
SITE <- read.csv("sites.csv")

############################

parametry <- data.frame(siteco = SITE$site_code, MeanRingWidth = NA, MeanAge = NA, FirstYear = NA, LastYear = NA)


for (i in c(1:nrow(SITE))){
   
serie1 <- read.rwl(paste("E:/TACR/zchron_TestData2/RWL/",SITE[i, "raw_data_file_name"], sep = "")) 

stats <- rwl.stats(serie1)

# Descriptive statistics per each site:    
parametry[i, "MeanRingWidth"] <- mean(stats$mean) # Mean tree-ring width
parametry[i, "MeanAge"] <- round(mean(stats$year), 1) # Mean age of sampled tree
parametry[i, "FirstYear"] <- min(stats$first) # Oldest measured ring
parametry[i, "LastYear"] <- max(stats$last) # Youngest measured ring (i.e., year of sampling, if the stand was living)

}

write.csv(parametry, "descriptive_parameters.csv") # Saves the table with output files into csv
