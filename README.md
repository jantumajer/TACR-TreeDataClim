### Select language

- English: [![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/jantumajer/TACR-TreeDataClim/blob/main/README.md)
- Čeština: [![cz](https://img.shields.io/badge/lang-cz-yellow.svg)](https://github.com/jantumajer/TACR-TreeDataClim/blob/main/README.cz.md)


# TreeDataClim Repository

### Team
Functions presented in this repository were developed for the assessment of growth trends, patterns of climatic limitations, and the identification of extreme growth reductions for dominant forest tree species across the Czech Republic. Their functionality was designed for processing tree-ring width series stored in the [TreeDataClim database](https://treedataclim.cz/en). The contributors of the data into this database include:
- [Charles University, Faculty of Science, Working group of Dendroecology](https://web.natur.cuni.cz/physgeo/dendro/)
- [Department of Forest Ecology, Silva Tarouca Research Institute, Blue Cat Team](https://pralesy.cz/lide)
- Forestry and Game Management Research Institute
- Mendel University in Brno, Faculty of Forestry and Wood Technology
- [University of Life Science, Faculty of Forestry and Wood Science, Department of Forest Ecology](https://www.remoteforests.org/?language=en)
- Institute of Botany of the Czech Academy of Sciences
- Jan Evangelista Purkyně University, Faculty of Environment

![obrazek](https://user-images.githubusercontent.com/25429975/235666459-c20a2ca5-748a-42ad-8c4c-44b9c8034a04.png)

### Acknowledgements and credits
The repository contains scripts and functions developed under the project funded by TAČR SS03010134 *Tree-ring database as a tool for description and prediction of responses of the main forest tree species to climate change*.

The development of the modified version of the VS-Lite process-based model of wood formation was largely inspired by the work of Dr. Suzan Tolwinski-Ward, mainly by Octave codes of the original model made available at [NOAA](https://www.ncei.noaa.gov/access/paleo-search/study/9894). Similarly, individual R functions use few publicly-available packages contributing to specific data processing steps and plotting charts. We are grateful to all authors of these packages for making them freely available.

### Functionality
This repository represents a compilation of stand-alone functions that were developed to process tree-ring width data following the methodology of the TreeDataClim project. The individual functions are grouped in the following folders:
- `Reductions`: functions to identify, evaluate, and extrapolate events of extreme growth reductions
- `Limitations`: a process-based model of intra-annual wood formation and its application to assess the type and the intensity of climatic limitation of wood formation on an intra-annual scale
- `Trends`: functions to quantify recent growth trends and to extrapolate their patterns across space
- `Misc (aka miscellaneous)`: pre-processing of dendrometer data required for subsequent functions, plotting of climatic diagrams

Each folder contains separate readme files explaining individual steps of the functions' application. Most functions were developed in [R language](https://www.r-project.org/) except the VS-Lite process-based model of wood formation, which is written in [Octave](https://octave.org/). Both languages are open-source. We recommend using the latest versions of both programming environments with our scripts.

The functions were developed and tested reflecting the structure of the TreeDataClim dataset and methodology, i.e., a dense network of tree-ring width series across the Czech Republic. However, the procedures can be directly applied to any other region of the world with available tree-ring width datasets. The functions' target period was 1961-2010 since we found it to be an optimal balance between the timespan of the analysis and the quality of the data (mainly the availability of reliable climatic data). Details about the required inputs and the way to apply each function are given as annotations in the specific script. Some functions require a prior installation of open-source packages and extensions both in R and Octave languages. Required packages and extensions are indicated at the beginning of each script. Specifically, these include ‘stk’ and ‘statistics’ (for Octave) and ‘reshape2’, ‘ggplot2’, ‘readxl’, ‘dplR’, ‘base’, ‘pointRes’, ‘ape’, ‘rgdal’, ‘openxlsx’, and ‘mgcv’ (for R).

### Inputs
Individual functions serve to process tree-ring width data following the methodology developed as a part of the TreeDataClim project. Individual inputs differ depending on each function and are indicated at the beginning of each script. The template of each input file can be found in the `Input` folder. This folder contains example data from 16 sites of two species (*Picea abies* and *Quercus robur*) distributed across the northern part of the Czech Republic.

### Contact and bug reporting
`Jan Tumajer` tumajerj@natur.cuni.cz

Charles University, Faculty of Science, Department of Physical Geography and Geoecology, Albertov 6, 12843 Prague, Czech Republic



`Jakub Kašpar` kaspar@vukoz.cz

Department of Forest Ecology, Silva Tarouca Research Institute, Blue Cat Team

