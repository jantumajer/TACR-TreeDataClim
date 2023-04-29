# TreeDataClim Package

### Acknowledgements and credits
This package contains scripts and functions developed under the project funded by TAČR SS03010134 "Databáze letokruhových chronologií jako nástroj pro evidenci a predikci reakce hlavních lesních dřevin na klimatickou změnu (Program Prostředí pro život)". 

The functions were developed to process tree-ring width series stored in TreeDataClim database (https://treedataclim.cz/). The contributors of the data into this database include:
- Charles University, Faculty of Science, Working group of Dendroecology (https://web.natur.cuni.cz/physgeo/dendro/)
- Department of Forest Ecology, Silva Tarouca Research Institute
- Forestry and Game Management Research Institute
- Mendel University in Brno, Faculty of Forestry and Wood Technology
- University of Life Science, Faculty of Forestry and Wood Science
- Institute of Botany of the Czech Academy of Sciences
- Jan Evangelista Purkyně University, Faculty of Environment

The development of the modified version of the VS-Lite process-based model of wood formation was largely inspired by the work of Suzan Tolwinski-Ward, mainly by Octave codes of the original model made available at NOAA (https://www.ncei.noaa.gov/access/paleo-search/study/9894)

### Functionality
This package represents a compilation of a stand-alone functions that were developed to process tree-ring width data following the methodology of TreeDataClim project. The individual groups of functions are as follows:
- `Misc (aka miscellaneous)` : pre-processing of dendrometer data required for subsequent functions, ploting of climatic diagrams
- `Reductions` : functions to identify, eveluate, and extrapolate events of extreme growth reductions
- `Limitations` : process-based model of intra-annual wood formation and its application to assess the type and the intensity of climatic limitation of wood formation
- `Trends` : functions to quantify recent growth trends and to extrapolate their patterns across space
All functions were developed in R programming language (https://www.r-project.org/) except the VS-Lite process-based model of wood formation, which is written in Octave (https://octave.org/). Both languages are open-source. We recommend to use the latest versions of both programming environments with our scripts.

### Inputs
Individual functions serve to process tree-ring width data following the methodology developed as a part of TreeDataClim project. Individual inputs differ depending on each function and are indicated at the beggining of each script. The example format of each input file can be found in the `Input` folder. 

### Applicability
The functions were developed and tested based on TreeDataClim dataset, i.e., a dense network of tree-ring width series across the Czech Republic. However, the functions can be directly applied to any other regions of the world with available tree-ring width datasets. The most functions target period 1961-2010, since we found this period as an optimal balance between temporal span of the analysis and quality of the data (mainly climatic datasets). Deatils about the required inputs and the way to apply each functions are given as notes in the specific script.

### Contact and bug reporting
Jan Tumajer, Charles University, Faculty of Science

tumajerj@natur.cuni.cz



### Production of extreme growth reductions maps (EGR)
Skripts were applied in the following order:

0a] `skript_popisne_statistiky.R`
- Basic descriptive statistics for each chronology - mean RW, mean age, first and last year


0b] `climadiagrams_facet.R`
- Plotting climatic diagrams for years of extreme growth reduction


1] `skript_pointeryF_imploctable.R`
##### The crucial script calculating EGR based on the following approach:
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
