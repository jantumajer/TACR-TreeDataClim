# TreeDataClim Package

### Team
Functions presented in this package were developed for the assessment of growth trends, patterns of climatic limitations, and the identification of extreme growth reductions for dominant forest tree species across the Czech Republic. Their functionality was designed for processing tree-ring width series stored in the [TreeDataClim database](https://treedataclim.cz/). The contributors of the data into this database include:
- [Charles University, Faculty of Science, Working group of Dendroecology](https://web.natur.cuni.cz/physgeo/dendro/)
- [Department of Forest Ecology, Silva Tarouca Research Institute, Blue Cat Team](https://pralesy.cz/lide)
- Forestry and Game Management Research Institute
- Mendel University in Brno, Faculty of Forestry and Wood Technology
- [University of Life Science, Faculty of Forestry and Wood Science, Department of Forest Ecology](https://www.remoteforests.org/?language=en)
- Institute of Botany of the Czech Academy of Sciences
- Jan Evangelista Purkyně University, Faculty of Environment

### Acknowledgements and credits
The package contains scripts and functions developed under the project funded by TAČR SS03010134 *Databáze letokruhových chronologií jako nástroj pro evidenci a predikci reakce hlavních lesních dřevin na klimatickou změnu (Program Prostředí pro život)*.

The development of the modified version of the VS-Lite process-based model of wood formation was largely inspired by the work of Dr. Suzan Tolwinski-Ward, mainly by Octave codes of the original model made available at [NOAA](https://www.ncei.noaa.gov/access/paleo-search/study/9894). Similarly, individual R functions use few publicly-available packages contributing to specific data processing steps and plotting charts. We are grateful to all authors of these packages for making them freely available.

### Functionality
This package represents a compilation of stand-alone functions that were developed to process tree-ring width data following the methodology of the TreeDataClim project. The individual groups of functions are as follows:
- `Reductions`: functions to identify, evaluate, and extrapolate events of extreme growth reductions
- `Limitations`: a process-based model of intra-annual wood formation and its application to assess the type and the intensity of climatic limitation of wood formation on an intra-annual scale
- `Trends`: functions to quantify recent growth trends and to extrapolate their patterns across space
- `Misc (aka miscellaneous)`: pre-processing of dendrometer data required for subsequent functions, plotting of climatic diagrams

All functions were developed in [R language](https://www.r-project.org/) except the VS-Lite process-based model of wood formation, which is written in [Octave](https://octave.org/). Both languages are open-source. We recommend using the latest versions of both programming environments with our scripts.

### Inputs
Individual functions serve to process tree-ring width data following the methodology developed as a part of the TreeDataClim project. Individual inputs differ depending on each function and are indicated at the beginning of each script. The template of each input file can be found in the `Input` folder. This folder contains example data from 16 sites of two species (**Picea abies** and **Quercus robur**) distributed across the northern part of the Czech Republic.

### Applicability
The functions were developed and tested reflecting the TreeDataClim dataset and methodology, i.e., a dense network of tree-ring width series across the Czech Republic. However, the procedures can be directly applied to any other region of the world with available tree-ring width datasets. The most functions target period was 1961-2010 since we found this period as an optimal balance between the period of the analysis and the quality of the data (mainly the availability of reliable climatic data). Details about the required inputs and the way to apply each function are given as annotations in the specific script. Some functions require a prior installation of open-source packages and extensions both in R and Octave languages. Required packages and extensions are indicated at the beginning of each script.

### Contact and bug reporting
Jan Tumajer

Charles University, Faculty of Science

Prague, Czech Republic

tumajerj@natur.cuni.cz
