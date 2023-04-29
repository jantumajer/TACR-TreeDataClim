###
### This is R-script to plot climatic diagram for given year ###
###

# Reguired open-source packages:
library(reshape2); library(ggplot2); library(readxl)
# Reguired input files
# Climatic dataset

############################

climateData <- read.csv("climate.csv")

# Calculating mean monthly temperatures and precipitation totals
AGG.ALL <- cbind(aggregate(climateData$Temp, by = list(MONTH = climateData$Month), FUN = mean),
                 aggregate(climateData$Prec, by = list(MONTH = climateData$Month), FUN = sum))
colnames(AGG.ALL) <- c("Month", "Temp", "Prec")

# Graph plotting
graph <- ggplot(data = AGG.ALL) +
  geom_bar(aes(y = Prec/10, x = Month), fill = "blue", stat = "identity", position = position_dodge())+
  geom_line(aes(y = Temp, x = Month), size = 0.5, col = "red")+
  scale_alpha_manual(values = c(0.3, 1.0)) +
  scale_x_continuous("Month", breaks = c(1:12))+
  scale_y_continuous("Temperature [°C]", limits = c(-8,25), breaks = c(-0,10,20), sec.axis = sec_axis(trans = ~.*10, name = "Precipitation [mm]",breaks = c(0, 100, 200)))+
  facet_grid(.~ factor(YEAR))+
  theme_classic() + 
  theme(panel.grid.major = element_blank(),
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

ggsave("Climadiagram.jpeg", width = 30, height = 6, unit = "cm", dpi = 1200) # Printing the output into jpeg
