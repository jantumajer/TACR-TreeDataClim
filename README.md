# TACR-TreeDataClim
R scripts used to process data in TACR TreeDataClim project


### Production of extreme growth reductions maps (EGR)
Skripts were applied in the following order:

0a] `skript_popisne_statistiky.R`
- Basic descriptive statistics for each chronology - mean RW, mean age, first and last year


0b] `climadiagrams_facet.R`
- Plotting climatic diagrams for years of extreme growth reduction


1] `skript_pointeryF_imploctable.R`
##### The crucial script calculating EGR based on defined approach:
- Filtering out of spurious *series*: series whose 30-years spline gets negative
- Filtering out non-robust *sites*: replication lower than 5 trees OR shorter than 40 years
- Calculation of z-chron chronology from detrended series (30-years spline) for the period since 1870
- z-transformed site chronology is subsetted to include only the negative pointers and ranked according to the intensity of the pointer (1 = largest deviation)
- Ranking of the intensity of the pointer is converted into recurrence frequency (frequency = ranking/chronology length)
- Relationship between reccurence frequency and pointer intensity (EGRZ) is smoothed using exponetnial
- The critical value of pointer intensity (EGRZ) for events with recurrence interval > 40 years is determined based on the exponetial equation
- All years with observed EGR exceeding critical threshold for 40-years reccurence are marked
- Legacy effects: If there are 2-5 consecutive years with EGR exceeding a 40-years threshold, their cumulative value is appended to the first year 


2] `skript_pointery_vyber_f1.R`
- Plotting diagnostic maps with distribution of responding and nonresponding sites for each year and species


3] `skript_regressions.R`
- Fitting linear regression models explaining EGR of a given year by site conditions
