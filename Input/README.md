# Templates of input files required by individual functions of this repository

**Tree-ring widths**: annual tree-ring widths measured per each tree stored in `rwl`<sup>1</sup> format

**Climate**: time series of monthly mean temperatures and monthly precipitation totals stored in `csv` (alt. `xls`, `xlsx`) formats

**Metadata**: site metadata; mandatory columns include the site name, coordinates, species, and link to *.rwl file with tree-ring width data of individual trees; the format of the metadata file is `csv`

**Country borders**: ESRI shapefile `shp` with country borders in WGS-84 projection (alternatively, any other type of geographical information<sup>2</sup> can be used)

**Inputs of the VS-Lite model**: site chronologies, climatic data, and metadata in a format readable by Octave

<sup>1</sup> `rwl` is a standard format for storing tree-ring width data used by the dendrochronological community. You can find details about this and other types of dendrochronological formats [here](https://www.treeringsociety.org/resources/SOM/Brewer_Murphy_SupplementaryMaterial.pdf).

<sup>2</sup> E.g., administrative borders, rivers, urban districts, biogeographical regions, etc.
