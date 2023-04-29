# TreeDataClim Package

### Acknowledgements and credits
The package contains scripts and functions developed under the project funded by TAČR SS03010134 *Databáze letokruhových chronologií jako nástroj pro evidenci a predikci reakce hlavních lesních dřevin na klimatickou změnu (Program Prostředí pro život)*. 

The functions were developed to process tree-ring width series stored in [TreeDataClim database](https://treedataclim.cz/). The contributors of the data into this database include:
- Charles University, Faculty of Science, [Working group of Dendroecology](https://web.natur.cuni.cz/physgeo/dendro/)
- Department of Forest Ecology, Silva Tarouca Research Institute
- Forestry and Game Management Research Institute
- Mendel University in Brno, Faculty of Forestry and Wood Technology
- University of Life Science, Faculty of Forestry and Wood Science
- Institute of Botany of the Czech Academy of Sciences
- Jan Evangelista Purkyně University, Faculty of Environment

The development of the modified version of the VS-Lite process-based model of wood formation was largely inspired by the work of Dr. Suzan Tolwinski-Ward, mainly by Octave codes of the original model made available at [NOAA](https://www.ncei.noaa.gov/access/paleo-search/study/9894)

### Functionality
This package represents a compilation of a stand-alone functions that were developed to process tree-ring width data following the methodology of TreeDataClim project. The individual groups of functions are as follows:
- `Misc (aka miscellaneous)` : pre-processing of dendrometer data required for subsequent functions, ploting of climatic diagrams
- `Reductions` : functions to identify, eveluate, and extrapolate events of extreme growth reductions
- `Limitations` : process-based model of intra-annual wood formation and its application to assess the type and the intensity of climatic limitation of wood formation
- `Trends` : functions to quantify recent growth trends and to extrapolate their patterns across space
All functions were developed in [R language](https://www.r-project.org/) except the VS-Lite process-based model of wood formation, which is written in [Octave](https://octave.org/). Both languages are open-source. We recommend to use the latest versions of both programming environments with our scripts.

### Inputs
Individual functions serve to process tree-ring width data following the methodology developed as a part of TreeDataClim project. Individual inputs differ depending on each function and are indicated at the beggining of each script. The example format of each input file can be found in the `Input` folder. 

### Applicability
The functions were developed and tested based on TreeDataClim dataset, i.e., a dense network of tree-ring width series across the Czech Republic. However, the functions can be directly applied to any other regions of the world with available tree-ring width datasets. The most functions target period 1961-2010, since we found this period as an optimal balance between temporal span of the analysis and quality of the data (mainly climatic datasets). Deatils about the required inputs and the way to apply each functions are given as notes in the specific script. Some functions require a prior installation of open-source packages and extensions both in R and Octave languages. Required packages and extensions are indicated at the beggining of each script.

### Contact and bug reporting
Jan Tumajer, Charles University, Faculty of Science

tumajerj@natur.cuni.cz
