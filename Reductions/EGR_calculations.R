###
### This is R-script to calculate basic descriptive statistics of tree-ring width series for each site ###
###

# Reguired open-source packages:
library(dplR);library(readxl); library(base); library(pointRes)
# Reguired input files
# Site tree-ring width series in *.rwl format
# Site metadata

############################

SITE <- read.csv("meta_github.csv")
parametry <- data.frame(siteco = SITE$site_code, a = NA, r = NA, negative.spline = NA, replication.less.5 = NA, shorter.than.40 = NA)
reccinterval <- data.frame(siteco = SITE$site_code, z40 = NA)
counter <- 1
nrs.for.spline <- 30 # Here define a spline length to be used for detrending of individual tree-ring width series


for (i in c(1:nrow(SITE))){
  
serie1 <- read.rwl(SITE[i, "raw_data_file_name"]) 

### Skript, ktery vypocte spliny a vyradi serie, pro ktere jde hodnota splinu pod nulu ###
zaporny.spline <- data.frame(SERIE = colnames(serie1), FLAG = NA)

for (j in c(1:ncol(serie1))){
  spline.fit <- ffcsaps(na.omit(serie1[,j]), nyrs = nrs.for.spline) # fituje spline
  zaporny.spline[j, "FLAG"] <- sum(spline.fit < 0) # Pocet nafitovanych hodnot pod nulou
  rm(spline.fit)
}

zachovat <- unique(zaporny.spline[zaporny.spline$FLAG == 0, "SERIE"])
serie1.subset <- serie1[, colnames(serie1) %in% zachovat]

parametry[counter, "negative.spline"] <- sum(zaporny.spline$FLAG > 1)/nrow(zaporny.spline)
print(paste("Ze souboru ", SITE[i, "raw_data_file_name"], " vyrazeno ", 100*round(parametry[counter, "negative.spline"], 2), " % serii", sep = ""))
########

serie2 <- detrend (serie1.subset, method = "Spline", nyrs = nrs.for.spline)
serie3 <- pointer.zchron (serie2, z.thresh = 0.01, make.plot = FALSE,
                          period = c(max(1870,min(as.numeric(rownames(serie2)))), # Odsekavam casti serii pred rokem 1870
                                     max(as.numeric(rownames(serie2)))))
serie4 <- serie3$out
numrows1 <- nrow(serie4)

if (max(serie4$nb.series) < 5) {parametry[counter, "replication.less.5"] <- 1}
if (max(serie4$nb.series) >= 5) { # Nove vlozena podminka, ktera nepristoupi k vymezeni rgc pro chronologie, ktere maji v momente maximalni replikace mene nez 5 stromu
  
  parametry[counter, "replication.less.5"] <- 0
  
serie5a <- subset(serie4, nb.series>=5)
serie5a$egrz <- serie5a$AVGztrans *-1
  serie5 <- subset(serie4, nb.series>=5 & AVGztrans<0)
  serie5$egrz <- serie5$AVGztrans *-1
  serie5$rankz <- rank(serie5$egrz, ties.method="min") # Zde byla zasadni chyba, nelze pouzivat first, protoze to prideli jine poradi stejne velkym rgc
                                                         # Jeste se muzeme dale pobavit o tom, jak by bylo toto optimalni resit
  numrows2 <- nrow(serie5)
  serie5$rankevent <- numrows2+1-serie5$rankz
  serie5$reccevent <- numrows1/serie5$rankevent
  fitserie <- nls(reccevent ~ a*exp(r*egrz), start = list(a=1, r=2), data = serie5, control = list(maxiter = 10000))
  parametry[counter, "a"] <- (coef(fitserie)) ["a"]
  parametry[counter, "r"] <- (coef(fitserie)) ["r"]
  reccinterval[counter, "z40"] <- (log(40/parametry[counter,"a"]))/parametry[counter, "r"]

  # Myslim, ze stoji za to si pro kontrolu vzdy nechat vykreslit graf fitu. Pripadne mozne vypoznamkovat
  plot(serie5$reccevent ~ serie5$rankevent, col = "blue", main = paste(SITE[i, "site_name"]))
  points(predict(fitserie) ~ serie5$rankevent, col = "red")
  abline(a = 40, b = 0)

  serie5$zfit <- predict(fitserie)
  serie5$zz40 <- ifelse(serie5$egrz>=reccinterval[counter, "z40"], 1,0)
  
  if(sum(serie5$zz40) == 0){parametry[counter, "shorter.than.40"] <- 1}
  if(sum(serie5$zz40) > 0){ # Nova podminka, ktera odfiltrovana serie kratsi 40 let a ty, ktere nemaji zadne ERGC
    parametry[counter, "shorter.than.40"] <- 0
    
    zoutput <- subset(serie5, zz40==1)
    zoutput <- zoutput[-c(2:4,6:9)]

    # Zde jsem pridal cast, ktera umozni nasledujici spojeni roku s RGC, kter jdou po sobe
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

    # Zde pocitam KUMULATIVNI ergz za celou dobu trvani (prvni rok + legacy). Pokud bys to chtel nahradit prumerem, dej vedet
    zoutput.2 <- aggregate(zoutput[,c("egrz", "zz40")], by = list(START.YEAR = zoutput$merge), FUN = sum)
    colnames(zoutput.2) <- c("START.YEAR", "ERGZ", "DURATION")
    zoutput.2$SITE <- paste(SITE[i, "site_code"])
    zoutput.2$lat <- paste(SITE[i, "site_lat"])
    zoutput.2$long <- paste(SITE[i, "site_long"])
    zoutput.2$elev <- paste(SITE[i, "elevation"])
    zoutput.2$spec <- paste(SITE[i, "species"])
    write.csv(zoutput.2, paste("E:/TACR/Vysledky/perSite/egrz/", SITE[i, "site_code"],"ergz.csv", sep = ""))
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

  write.csv(serie5, paste("E:/TACR/Vysledky/perSite/bla/", SITE[i, "site_code"],"bla.csv", sep = ""))
  write.csv(serie5a, paste("E:/TACR/Vysledky/perSite/blall/", SITE[i, "site_code"],"blall.csv", sep = ""))
  
  rm(serie1,serie1.subset, serie2, serie3, serie4, serie5, numrows2, numrows1, fitserie, zoutput, zoutput.2,
     zaporny.spline, zachovat)
}
  counter<- counter+1
  
}

write.csv(parametry, "E:/TACR/Vysledky/parametry_fit_exponetnial.csv")
