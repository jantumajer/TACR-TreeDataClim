###
### R-script for a spatial regression of observed values of z-chronology in given year ###
###

# Reguired open-source packages:
library(readxl); library(ape)
# Reguired input files:
# Site metadata
# Site-specific values of z-chronology for each year as produced by EGR_calculations.R

############################

sites <- read.csv("meta.csv", row.names=1) # Load metadata

for_regression <- data.frame(SITE = NA, SPECIES = NA, YEAR = NA, LAT = NA, LON = NA, ELEV = NA, EGRZ = NA) # Prepare dataframe that will be filled by value of EGR (dependent variable) and geographical features (explanatory predictors)
for_regression <- for_regression[-1, ]
counter <- 1

species <- "PCAB" # Select species 
sites.SPEC <- sites[sites$species == species, ] # Subsample of sites with presence of a given species

pointer.year <- 1976 # Select important EGR year (identify them e.g., using maps produced by script EGR_spatial.R)

      
for (k in c(1:nrow(sites.SPEC))){ # This script extracts a value of z-chron chronology for each site of given species and given year and prepares the table ready for regression models
          
     dat <- read.csv(paste(sites.SPEC[k, "site_code"], "blall.csv", sep = "")) # Load 'blall' file, i.e., dataframe with values of z-chronology for each site and each year
      # This file is produced by EGR_calculation.R, line
          
     for_regression[counter, "SITE"] <- sites.SPEC[k, "site_code"]
     for_regression[counter, "SPECIES"] <- sites.SPEC[k, "species"]
     for_regression[counter, "YEAR"] <- pointer.year
     for_regression[counter, "LAT"] <- sites.SPEC[k, "site_lat"]
     for_regression[counter, "LON"] <- sites.SPEC[k, "site_long"]
     for_regression[counter, "ELEV"] <- sites.SPEC[k, "elevation"]
     # Alternatively, you can add here more optional columns available in metadata file, e.g., soil conditions

     if(pointer.year %in% dat$year) {for_regression[counter, "EGRZ"] <- dat[dat$year == pointer.year, "egrz"]}
          
     rm(dat)
     counter <- counter + 1

 }

for_regression_withoutNA <- for_regression[!(is.na(for_regression$EGRZ)),]

### Regression - linear model
    mod <- lm(EGRZ ~ LAT + LON + ELEV, data = for_regression_withoutNA)
    sum.mod <- summary(mod)
    print(sum.mod)
