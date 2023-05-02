library(dplR);library(readxl); library(base); library(ggplot2); library(rgdal)
full.sitelist <- read.csv("E:/TACR/zchron_TestData2/META/data_april2_withCZU.csv")
colnames(full.sitelist)[5] <- "spec"

seznam<-list.files ("E:/TACR/Vysledky/perSite/egrz/")
taball4<-data.frame (sitelist = seznam)

tabspojena<-data.frame(X=NA, START.YEAR=NA, ERGZ=NA, DURATION=NA, SITE=NA, lat=NA, long=NA, elev=NA, spec=NA)
tabspojena <- tabspojena[-1,]

for (i in c(1:nrow(taball4))){
  tabula1 <- read.csv(paste("E:/TACR/Vysledky/perSite/egrz/", taball4[i, "sitelist"], sep = ""), sep = ",", header = TRUE) 
  tabspojena<- rbind (tabspojena, tabula1)

  rm(tabula1)
  
}

tabspoj60x<- subset (tabspojena, START.YEAR>=1961)

# Definition of species groups
tabspoj60x$spec.groups <- "OTHER"
tabspoj60x[tabspoj60x$spec %in% c("QURO", "QUPE", "QUSP", "QUsp"), "spec.groups"] <- "QU_aggregated"
tabspoj60x[tabspoj60x$spec %in% c("PCAB"), "spec.groups"] <- "PCAB"
tabspoj60x[tabspoj60x$spec %in% c("PISY"), "spec.groups"] <- "PISY"
tabspoj60x[tabspoj60x$spec %in% c("ABAL"), "spec.groups"] <- "ABAL"
tabspoj60x[tabspoj60x$spec %in% c("FASY"), "spec.groups"] <- "FASY"
tabspoj60x[tabspoj60x$spec %in% c("LADE"), "spec.groups"] <- "LADE"

full.sitelist$spec.groups <- "OTHER"
full.sitelist[full.sitelist$spec %in% c("QURO", "QUPE", "QUSP", "QUsp"), "spec.groups"] <- "QU_aggregated"
full.sitelist[full.sitelist$spec %in% c("PCAB"), "spec.groups"] <- "PCAB"
full.sitelist[full.sitelist$spec %in% c("PISY"), "spec.groups"] <- "PISY"
full.sitelist[full.sitelist$spec %in% c("ABAL"), "spec.groups"] <- "ABAL"
full.sitelist[full.sitelist$spec %in% c("FASY"), "spec.groups"] <- "FASY"
full.sitelist[full.sitelist$spec %in% c("LADE"), "spec.groups"] <- "LADE"

####### Ploting of diagnostic maps ############
shp <- readOGR(dsn = "e:/SHAPEFILE/cr2.shp", stringsAsFactors = F) # Zde nutne nacist shapefile CR ve WGS84

for (year in c(1961:2020)){

full.sitelist.sub <- full.sitelist[(!(is.na(full.sitelist$last_year)) & full.sitelist$last_year > (year-1)), ]
full.sitelist.agg <- aggregate(full.sitelist.sub$X, by = list(spec.groups = full.sitelist.sub$spec.groups), FUN = NROW)

tabspoj60x.sub <- tabspoj60x[tabspoj60x$START.YEAR == year,]

if(nrow(tabspoj60x.sub) > 0){
  tabspoj60x.agg <- aggregate(tabspoj60x.sub$X, by = list(spec.groups = tabspoj60x.sub$spec.groups), FUN = NROW)
  agg.both <- merge(tabspoj60x.agg, full.sitelist.agg, by = "spec.groups")

  map <- ggplot() +
    geom_polygon(aes(x = long, y = lat, group = group), col = "black", fill = NA, data = shp) +
    geom_point(aes(x = site_long, y = site_lat), size = 1, alpha = 0.1, pch = 3, data = full.sitelist.sub, position = position_jitter()) +
    geom_point(aes(x = long, y = lat, col = ERGZ/DURATION, size = DURATION), data = tabspoj60x.sub, position = position_jitter()) +
    geom_label(x = 18, y = 50.75, aes(label = paste(x.x, "/", x.y, " = ", round(x.x/x.y, 2)), sep = ""), size = 4, data = agg.both) +
    scale_color_gradient(limits = c(0,5), low = "green", high = "red") +
    scale_size_continuous(range = c(0, 6), limits = c(0, 5)) +
    ggtitle(paste(year)) +
    facet_wrap(spec.groups ~ .) +
    theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_rect(fill = NA, colour = "grey20"),
        axis.line = element_line(colour = "black"),
        axis.text = element_text(size = 14, colour = "black"),
        axis.title = element_text(size = 16, colour = "black"),
        axis.ticks.length=unit(.3, "cm"),
        strip.text = element_text(size = 18, colour = "black"),
        plot.title = element_text(color = "black", hjust = 0.5, vjust = 0, face = "bold", size = 18))
  map

  ggsave(paste("e:/TACR/Maps/", year, ".jpeg", sep = ""), width = 15, height = 10, dpi = 250)
  }
}
