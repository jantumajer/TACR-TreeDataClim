# Identification of years with extreme growth reduction (EGR) and their spatial interpolation 
Skripts were applied in the following order:

1] `EGR calculations.R`
##### The crucial script calculating EGR based on the following approach:
- Filtering out spurious series: series whose 30-years spline gets negative
- Filtering out non-robust sites: replication lower than 5 trees OR shorter than 40 years
- Calculation of z-chron chronology from detrended series (30-years spline) for the period since 1870
- z-transformed site chronology is subset to include only the negative pointers and ranked according to the intensity of the pointer (1 = largest deviation)
- Ranking of the intensity of the pointer is converted into recurrence frequency (frequency = ranking/chronology length)
- Relationship between reccurence frequency and pointer intensity (EGRZ) is modeled using exponetnial regression
- The critical value of pointer intensity (EGRZ) for events with recurrence interval > 40 years is determined based on the exponetial equation
- All years with observed EGR exceeding critical threshold for 40-years reccurence are marked as extreme growth reductions
- Legacy effects: If there are 2-5 consecutive years with EGR exceeding a 40-years threshold, their cumulative value is appended to the first year 

Reference: *Treml, V., Mašek, J., Tumajer, J., Rydval, M., Čada, V., Ledvinka, O., Svoboda, M., 2022. Trends in climatically driven extreme growth reductions of Picea abies and Pinus sylvestris in Central Europe. Global Change Biology 28, 557–570. https://doi.org/10.1111/gcb.15922*

2] `skript_pointery_vyber_f1.R`
- Plotting diagnostic maps with distribution of responding and nonresponding sites for each year and species


3] `skript_regressions.R`
- Fitting linear regression models explaining EGR of a given year by site conditions
