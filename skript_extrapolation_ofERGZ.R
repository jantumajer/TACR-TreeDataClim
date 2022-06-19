###################
### Priprava - odmazani bodu z nelesni pudy
###################

# cz50 <- read.csv2("E:/TACR/Regresni_Modely/cz50.txt")

# cz50.onlyForest <- cz50[!(cz50$Site_cat == " " | cz50$Site_cat == "NO_DATA"),]
# write.csv(cz50.onlyForest, "E:/TACR/Regresni_Modely/cz50_onlyForest.txt", row.names = F)


regrese <- read.csv("E:/TACR/Regresni_Modely/fitted_models.csv")
cz50.onlyForest <- read.csv2("E:/TACR/Regresni_Modely/cz50_onlyForest.txt", sep = ",")

for (i in c(1:nrow(regrese))){ # For each pointer
  
  name.of.pointer <- paste(regrese[i, "SPECIES"], regrese[i, "YEAR"], sep = "_")
  
  par.X <- regrese[i, "LON_coef"]
  par.Y <- regrese[i, "LAT_coef"]
  par.Intercept <- regrese[i, "INTERC_coef"]
  par.Elev <- regrese[i, "ELEV_coef"]
  par.SFextreme <- regrese[i, "SF_extreme_coef"]
  par.SFmoderate <- regrese[i, "SF_moderate_coef"]
  par.SFmoist <- regrese[i, "SF_moist_coef"]
  par.SFrich <- regrese[i, "SF_rich_coef"]
  
  SAVE <- data.frame(ERGZmod = NA); colnames(SAVE) <- name.of.pointer
  
  for (j in c(1:nrow(cz50.onlyForest))){ # For each pixel
    
    pixel <- cz50.onlyForest[j,]
    
    if(pixel[1,"Site_cat"] == "extreme"){par.SF <- par.SFextreme}
    if(pixel[1,"Site_cat"] == "moderate"){par.SF <- par.SFmoderate}
    if(pixel[1,"Site_cat"] == "moist"){par.SF <- par.SFmoist}
    if(pixel[1,"Site_cat"] == "rich"){par.SF <- par.SFrich}
    if(pixel[1,"Site_cat"] == "acid"){par.SF <- 0}
    
                    # Intercept glob+SF               longitude                                          latitude                                  elevation
    SAVE[j, 1] <- (par.Intercept + par.SF) + (par.X * as.numeric(pixel[1, "xcor"])) + (par.Y * as.numeric(pixel[1, "ycor"])) + (par.Elev * as.numeric(pixel[1, "elevation"]))
    
    rm(pixel, par.SF)
  }
  
  cz50.onlyForest.SAVE <- cbind(cz50.onlyForest, SAVE)
  print(paste(name.of.pointer, "finished"))
  write.csv(cz50.onlyForest, paste("E:/TACR/Regresni_Modely/Results/", name.of.pointer, ".txt", sep = ""), row.names = F)
  
  rm(SAVE, par.Elev, par.Intercept, par.SFextreme, par.SFmoderate, par.SFmoist, par.SFrich, par.X, par.Y, name.of.pointer)
  
}

