library(readxl); library(ape)

sites <- read.csv("meta.csv", row.names=1)
fit_parameters <- read.csv("E:/TACR/Vysledky/parametry_fit_exponetnial.csv", row.names=1)


for_regression <- data.frame(SITE = NA, SPECIES = NA, YEAR = NA, LAT = NA, LON = NA, ELEV = NA, EGRZ = NA)
for_regression <- for_regression[-1, ]
counter <- 1

species <- "PCAB" # Select species 
sites.SPEC <- sites[sites$species == species, ] # Subsample of sites with presence of a given species

pointer.year <- 1976 # Select important EGR year (identify them e.g., using maps produced by script EGR_spatial.R)

      
for (k in c(1:nrow(sites.SPEC))){ # This script extracts a value of z-chron chronology for each site of given species and given year and prepares the table ready for regression models
        
  if (!(sites.SPEC[k, "raw_data_file_name"] == "") &
      fit_parameters[fit_parameters$siteco == sites.SPEC[k, "site_code"], "replication.less.5"] == 0 &
      fit_parameters[fit_parameters$siteco == sites.SPEC[k, "site_code"], "shorter.than.40"] == 0){
          
     dat <- read.csv(paste("e:/TACR/Vysledky/perSite/blall/", sites.SPEC[k, "site_code"], "blall.csv", sep = ""))
          
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
 }

for_regression_withoutNA <- for_regression[!(is.na(for_regression$EGRZ)),]

### Regression - linear model
    mod <- lm(EGRZ ~ LAT + LON + ELEV, data = for_regression_withoutNA)
    sum.mod <- summary(mod)
    print(sum.mod)
