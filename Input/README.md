# Templates of input files required by individual functions of this repository

**Tree-ring widths**: annual tree-ring widths measured per each tree stored in `rwl`<sup>1</sup> format

![obrazek](https://user-images.githubusercontent.com/25429975/235675803-a9e96dd3-5a51-4362-b210-b583240a31c8.png)

**Climate**: time series of monthly mean temperatures and monthly precipitation totals stored in `csv` (alt. `xls`, `xlsx`) formats

![obrazek](https://user-images.githubusercontent.com/25429975/235675991-6658f40d-49fd-47b3-a493-ab15866ca529.png)

**Metadata**: site metadata; mandatory columns include the site name, coordinates, species, and link to *.rwl file with tree-ring width data of individual trees; the format of the metadata file is `csv`

![obrazek](https://user-images.githubusercontent.com/25429975/235676228-e142ca25-0203-43a7-92d8-d184d48c983d.png)

**Country borders**: ESRI shapefile `shp` with country borders in WGS-84 projection (alternatively, any other type of geographical information<sup>2</sup> can be used)

**Inputs of the VS-Lite model**: site chronologies, climatic data, and metadata in a format readable by Octave

<sup>1</sup> `rwl` is a standard format for storing tree-ring width data used by the dendrochronological community. You can find details about this and other types of dendrochronological formats [here](https://www.treeringsociety.org/resources/SOM/Brewer_Murphy_SupplementaryMaterial.pdf).

<sup>2</sup> E.g., administrative borders, rivers, urban districts, biogeographical regions, etc.
