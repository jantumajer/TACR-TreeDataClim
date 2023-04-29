###
### R-script to plot climatic diagram for given site ###
###

# Reguired open-source packages:
library(reshape2); library(ggplot2); library(readxl)
# Reguired input files
# Climatic dataset

############################

climateData <- read.csv("P000016QURO_clim.csv") # Select the site for which to plot a climatic diagram

# Calculating mean monthly temperatures and precipitation totals
AGG.ALL <- cbind(aggregate(climateData$Temp, by = list(MONTH = climateData$Month), FUN = mean),
                 aggregate(climateData$Prec, by = list(MONTH = climateData$Month), FUN = sum)$x/length(unique(climateData$Year)))
colnames(AGG.ALL) <- c("Month", "Temp", "Prec")

# Graph plotting
graph <- ggplot(data = AGG.ALL) +
  geom_rect(aes(ymin = -8, ymax = Prec/10, xmin = Month-0.4, xmax = Month+0.4), fill = "blue", stat = "identity", position = position_dodge())+
  geom_line(aes(y = Temp, x = Month), linewidth = 0.5, col = "red")+
  scale_x_continuous("Month", breaks = c(1:12))+
  scale_y_continuous("Temperature [°C]", limits = c(-8,25), breaks = c(-0,10,20), sec.axis = sec_axis(trans = ~.*10, name = "Precipitation [mm]",breaks = c(0, 100, 200)))+
  theme_classic() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_rect(fill = NA, colour = "grey20"),
        axis.line = element_line(colour = "black"),
        axis.text = element_text(size = 10, colour = "black"),
        axis.title = element_text(size = 10, colour = "black"),
        axis.ticks.length=unit(.15, "cm"),
        legend.position = "none",
        strip.text = element_text(size = 10, colour = "black"),
        strip.background = element_rect(color = NA),
        plot.title = element_blank())

graph

ggsave("Climadiagram.jpeg", width = 10, height = 6, unit = "cm", dpi = 1200) # Printing the output into jpeg
