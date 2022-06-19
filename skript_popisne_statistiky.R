library(dplR);library(readxl); library(base); library(pointRes)

SITE <- read.csv("E:/TACR/zchron_TestData2/META/data_april2_withCZU.csv")
parametry <- data.frame(siteco = SITE$site_code, MeanRingWidth = NA, MeanAge = NA, FirstYear = NA, LastYear = NA)


for (i in c(1:nrow(SITE))){
  
  if (!(SITE[i, "raw_data_file_name"] == "")){ # Podminka vlozena do te doby, nez Cada a Rydval poslou svoje rwl soubory
  
serie1 <- read.rwl(paste("E:/TACR/zchron_TestData2/RWL/",SITE[i, "raw_data_file_name"], sep = "")) 

stats <- rwl.stats(serie1)

parametry[i, "MeanRingWidth"] <- mean(stats$mean)
parametry[i, "MeanAge"] <- round(mean(stats$year), 1)
parametry[i, "FirstYear"] <- min(stats$first)
parametry[i, "LastYear"] <- max(stats$last)


  }
}

write.csv(parametry, "E:/TACR/Vysledky/descriptive_parameters.csv")
