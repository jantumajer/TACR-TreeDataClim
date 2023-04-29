library(readxl); library(ape)

pointers <- read_excel("E:/TACR/Regresni_Modely/pointer_selection3.xlsx")
sites <- read.csv("E:/TACR/Regresni_Modely/tabfull1.csv", row.names=1, sep=";")
fit_parameters <- read.csv("E:/TACR/Vysledky/parametry_fit_exponetnial.csv", row.names=1)


for_regression <- data.frame(SITE = NA, SPECIES = NA, YEAR = NA, LAT = NA, LON = NA, ELEV = NA, SITE_FAC = NA, EGRZ = NA)
for_regression <- for_regression[-1, ]
counter <- 1

for (i in unique(colnames(pointers))){
  sites.SPEC <- sites[sites$species == i, ] # Subsample of sites with presence of a given species
  
  for (j in c(1:nrow(pointers[,colnames(pointers) == i]))){ # For each pointer of given species
    pointer.year <- as.numeric(pointers[j ,colnames(pointers) == i])
    
    if (!(is.na(pointer.year))){
      
      for (k in c(1:nrow(sites.SPEC))){
        
        if (!(sites.SPEC[k, "raw_data_f"] == "") &
            fit_parameters[fit_parameters$siteco == sites.SPEC[k, "site_code"], "replication.less.5"] == 0 &
            fit_parameters[fit_parameters$siteco == sites.SPEC[k, "site_code"], "shorter.than.40"] == 0){
          
          dat <- read.csv(paste("e:/TACR/Vysledky/perSite/blall/", sites.SPEC[k, "site_code"], "blall.csv", sep = ""))
        
          for_regression[counter, "SITE"] <- sites.SPEC[k, "site_code"]
          for_regression[counter, "SPECIES"] <- sites.SPEC[k, "species"]
          for_regression[counter, "YEAR"] <- pointer.year
          for_regression[counter, "LAT"] <- sites.SPEC[k, "site_lat_d"]
          for_regression[counter, "LON"] <- sites.SPEC[k, "site_long_"]
          for_regression[counter, "ELEV"] <- sites.SPEC[k, "elevation"]
          for_regression[counter, "SITE_FAC"] <- sites.SPEC[k, "site_categ"]
          

          if(pointer.year %in% dat$year) {for_regression[counter, "EGRZ"] <- dat[dat$year == pointer.year, "egrz"]}
        
          rm(dat)
          counter <- counter + 1
        }
      }
      
    }
    rm(pointer.year)
  }
  
}

for_regression_withoutNA <- for_regression[(!(is.na(for_regression$EGRZ)) & !(for_regression$SITE_FAC == "NO_DATA")),]

for_regression_withoutNA[for_regression_withoutNA$SPECIES == "FASY", "SPECIES2"] <- "FASY"
for_regression_withoutNA[for_regression_withoutNA$SPECIES == "PCAB", "SPECIES2"] <- "PCAB"
for_regression_withoutNA[for_regression_withoutNA$SPECIES == "ABAL", "SPECIES2"] <- "ABAL"
for_regression_withoutNA[for_regression_withoutNA$SPECIES == "PISY", "SPECIES2"] <- "PISY"
for_regression_withoutNA[for_regression_withoutNA$SPECIES %in% c("QURO", "QUPE", "QUSP", "QUsp"), "SPECIES2"] <- "QU"

### Regression
Param <- data.frame(SPECIES = NA, YEAR = NA, INTERC_coef = NA, INTERC_p = NA, LAT_coef = NA, LAT_p = NA, LON_coef = NA, LON_p = NA, ELEV_coef = NA, ELEV_p = NA,
                    SF_extreme_coef = NA, SF_extreme_p = NA, SF_moderate_coef = NA, SF_moderate_p = NA, 
                    SF_moist_coef = NA, SF_moist_p = NA, SF_rich_coef = NA, SF_rich_p = NA, R2 = NA,
                    MoranI_latlon = NA, MoranI_latlon_p = NA, MoranI_elev = NA, MoranI_elev_p = NA)

counter <- 1
for (i in unique(for_regression_withoutNA$SPECIES2)){
  sub1 <- for_regression_withoutNA[for_regression_withoutNA$SPECIES2 == i, ]
  
  for (j in unique(sub1$YEAR)){
    sub2 <- sub1[sub1$YEAR == j,]
    
    ### Linearni model
    mod <- lm(EGRZ ~ LAT + LON + ELEV + SITE_FAC, data = sub2)
    sum.mod <- summary(mod)
    
    Param[counter, "SPECIES"] <- i
    Param[counter, "YEAR"] <- j
    Param[counter, "INTERC_coef"] <- mod$coefficients["(Intercept)"]
    Param[counter, "LAT_coef"] <- mod$coefficients["LAT"]
    Param[counter, "LON_coef"] <- mod$coefficients["LON"]
    Param[counter, "ELEV_coef"] <- mod$coefficients["ELEV"]
    Param[counter, "SF_extreme_coef"] <- mod$coefficients["SITE_FACextreme"]
    Param[counter, "SF_moderate_coef"] <- mod$coefficients["SITE_FACmoderate"]
    Param[counter, "SF_moist_coef"] <- mod$coefficients["SITE_FACmoist"]
    Param[counter, "SF_rich_coef"] <- mod$coefficients["SITE_FACrich"]
    
    if(sum.mod$coefficients["(Intercept)", 4] < 0.05){Param[counter, "INTERC_p"] <- 1
      } else {Param[counter, "INTERC_p"] <- 0}
    if(sum.mod$coefficients["LAT", 4] < 0.05){Param[counter, "LAT_p"] <- 1
      } else {Param[counter, "LAT_p"] <- 0}    
    if(sum.mod$coefficients["LON", 4] < 0.05){Param[counter, "LON_p"] <- 1
      } else {Param[counter, "LON_p"] <- 0}    
    if(sum.mod$coefficients["ELEV", 4] < 0.05){Param[counter, "ELEV_p"] <- 1
      } else {Param[counter, "ELEV_p"] <- 0}    
    if(sum.mod$coefficients["SITE_FACextreme", 4] < 0.05){Param[counter, "SF_extreme_p"] <- 1
      } else {Param[counter, "SF_extreme_p"] <- 0}    
    if(sum.mod$coefficients["SITE_FACmoderate", 4] < 0.05){Param[counter, "SF_moderate_p"] <- 1
      } else {Param[counter, "SF_moderate_p"] <- 0}    
    if(sum.mod$coefficients["SITE_FACmoist", 4] < 0.05){Param[counter, "SF_moist_p"] <- 1
      } else {Param[counter, "SF_moist_p"] <- 0}    
    if(sum.mod$coefficients["SITE_FACrich", 4] < 0.05){Param[counter, "SF_rich_p"] <- 1
    } else {Param[counter, "SF_rich_p"] <- 0}  
    
    Param[counter, "R2"] <- sum.mod$r.squared
    
    ### Moranovo I na residualy
    distance.matrix.2d <- as.matrix(dist(cbind(sub2$LAT, sub2$LON))) # In degrees! - incorrect - not SJTSK
    distance.matrix.2d.inv <- 1/distance.matrix.2d
    distance.matrix.2d.inv[distance.matrix.2d.inv == Inf] <- 0
    diag(distance.matrix.2d.inv) <- 0

    distance.matrix.elev <- as.matrix(dist(cbind(sub2$ELEV))) # In degrees! - incorrect - not SJTSK
    distance.matrix.elev.inv <- 1/distance.matrix.elev
    distance.matrix.elev.inv[distance.matrix.elev.inv == Inf] <- 0
    diag(distance.matrix.elev.inv) <- 0    
    
    Param[counter, "MoranI_latlon"] <- Moran.I(x = mod$residuals, weight = distance.matrix.2d.inv)$observed
    Param[counter, "MoranI_elev"] <- Moran.I(x = mod$residuals, weight = distance.matrix.elev.inv)$observed
    if (Moran.I(x = mod$residuals, weight = distance.matrix.2d.inv)$p.value < 0.05) {Param[counter, "MoranI_latlon_p"] <- 1
      } else {Param[counter, "MoranI_latlon_p"] <- 0}
    if (Moran.I(x = mod$residuals, weight = distance.matrix.elev.inv)$p.value < 0.05) {Param[counter, "MoranI_elev_p"] <- 1
      } else {Param[counter, "MoranI_elev_p"] <- 0}

    rm(mod, sum.mod,
       distance.matrix.2d, distance.matrix.2d.inv, distance.matrix.elev, distance.matrix.elev.inv)
    
    counter <- counter + 1
  }
  
}

write.csv(Param, "e:/TACR/Regresni_Modely/fitted_models.csv", row.names = F)
