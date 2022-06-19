library(reshape2); library(ggplot2); library(readxl)

# Preselected pointers
pointers <- read_excel("E:/TACR/Regresni_Modely/pointer_selection3.xlsx")[,c(1:4, 8)]
colnames(pointers)[4] <- "QU_aggregated"
pointers.melt <- melt(pointers)
pointers.melt <- pointers.melt[!(is.na(pointers.melt$value)),]

# Climatic datasets
climateData <- read.csv("e:/TACR/Climate_Grids/Climate_tables/ALL.csv")

# list of responding sites
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

####

pointers.melt.FASY <- pointers.melt[pointers.melt$variable == "PCAB",]

AGG.ALL <- data.frame(Month = NA, Temp = NA, Prec = NA, PERIOD = NA, AREA = NA, YEAR = NA, SPECIES = NA)
AGG.ALL <- AGG.ALL[-1,]

for (i in c(1:nrow(pointers.melt.FASY))){
  spec <- pointers.melt.FASY[i, "variable"]
  year <- pointers.melt.FASY[i, "value"]
  responders <- tabspoj60x[tabspoj60x$START.YEAR == year & tabspoj60x$spec.groups == spec,]
  
  responsive <- climateData[climateData$spec == spec & climateData$Year < 2001 & climateData$site %in% responders$SITE,]
  responsive.year <- climateData[climateData$spec == spec & climateData$Year == year & climateData$site %in% responders$SITE,]
  AGG.responsive <- aggregate(responsive[,c("Temp", "Prec")], by = list(Month = responsive$Month), FUN = mean)
  AGG.responsive.year <- aggregate(responsive.year[,c("Temp", "Prec")], by = list(Month = responsive.year$Month), FUN = mean)
  
  AGG <- rbind(cbind(AGG.responsive, PERIOD = "1960-2000", AREA = "responsive", YEAR = year, SPECIES = spec),
                   cbind(AGG.responsive.year, PERIOD = "Pointer year", AREA = "responsive", YEAR = year, SPECIES = spec))
  
  AGG.ALL <- rbind(AGG.ALL, AGG)
  rm(AGG)
}

library(showtext) # Adding specific fonts
font_add("Century Gothic", "GOTHIC.TTF")
font_families()
showtext_auto()

graph <- ggplot(data = AGG.ALL[AGG.ALL$YEAR > 1981,]) +
  geom_bar(aes(y = Prec/10, x = Month, alpha = PERIOD), fill = "blue", stat = "identity", position = position_dodge())+
  geom_line(aes(y = Temp, x = Month, alpha = PERIOD), size = 0.5, col = "red")+
  scale_alpha_manual(values = c(0.3, 1.0)) +
  scale_x_continuous("Mìsíc", breaks = c(1:12))+
  scale_y_continuous("Teplota [°C]", limits = c(-8,25), breaks = c(-0,10,20), sec.axis = sec_axis(trans = ~.*10, name = "Srážky [mm]",breaks = c(0, 100, 200)))+
  facet_grid(.~ factor(YEAR))+
  theme_classic() + 
  theme(text=element_text(family="Century Gothic"),
        panel.spacing.x = unit(2, "cm"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_rect(fill = NA, colour = "grey20"),
        axis.line = element_line(colour = "black"),
        axis.text = element_text(size = 100, colour = "black"),
        axis.title = element_text(size = 100, colour = "black"),
        axis.ticks.length=unit(.15, "cm"),
        legend.position = "none",
        strip.text = element_text(size = 100, colour = "black"),
        strip.background = element_rect(color = NA),
        plot.title = element_blank())

graph

ggsave("e:/TACR/Climate_Grids/Climatediagrams/PCAB_2.jpeg", width = 30, height = 6, unit = "cm", dpi = 1200)
