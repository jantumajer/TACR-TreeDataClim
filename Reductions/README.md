# Identification of years with extreme growth reductions (EGR) and their spatial interpolation
Scripts were applied in the following order:

1] `EGR calculations.R`
##### A crucial script calculating EGR based on the following approach:
- Filtering out spurious series: series whose 30-years spline gets negative
- Filtering out non-robust sites: replication lower than 5 trees OR shorter than 40 years
- Calculation of z-chron chronology from detrended series (30-year spline) for the period since 1870
- z-transformed site chronology is a subset to include only the negative pointers and ranked according to the intensity of the pointer (1 = largest deviation)
- Ranking of the intensity of the pointer is converted into recurrence frequency (frequency = ranking/chronology length)
- Relationship between recurrence frequency and pointer intensity (EGRZ) is modeled using exponential regression
- The critical value of pointer intensity (EGRZ) for events with recurrence interval > 40 years is determined based on the exponential equation
- All years with observed EGR exceeding a critical threshold for 40-year recurrence are marked as extreme growth reductions
- Legacy effects: If there are 2-5 consecutive years with EGR exceeding a 40-year threshold, their cumulative value is appended to the first year

![obrazek](https://user-images.githubusercontent.com/25429975/235674470-5f3af2e5-a1e5-4205-a6bb-55ba077987e2.png)
*Illustration of recurrence interval (RI) calculation starting from original time series of relative growth changes (“RGCinv”; a). Relative growth change (RGCs) were ranked according to their size and fitted with an exponential function (b). The theoretical recurrence interval of RGCinv event with given intensity (order) depends on tree age (i.e., the length of the series; c). RGCinv values corresponding to 15- or 50- year recurrence intervals were computed using a theoretical fitted exponential distribution (d). All RGCs exceeding 15- or 50- year recurrence interval threshold values were defined as extreme growth reductions (e)*

Reference: *Treml, V., Mašek, J., Tumajer, J., Rydval, M., Čada, V., Ledvinka, O., Svoboda, M., 2022. Trends in climatically driven extreme growth reductions of Picea abies and Pinus sylvestris in Central Europe. Global Change Biology 28, 557–570. https://doi.org/10.1111/gcb.15922*

2] `EGR spatial.R`
- Plotting diagnostic maps with a spatial distribution of sites showing significant and non-significant EGRs in a given year

![1976](https://user-images.githubusercontent.com/25429975/235671844-3c5a5be4-22dc-417b-b449-c74d13cc1660.jpeg)

3] `EGR_regressions.R`
- Linear regression models explaining a spatial distribution of EGRs in a given year by site conditions
