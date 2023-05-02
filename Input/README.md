# Example input files required by individual functions of this repository

**Tree-ring widths** : annual tree-ring widths measured per each tree stored in `rwl`[^1] format

**Climate** : timeseries of monthly mean temperatures and monthly precipitation totals stored in `csv` (alt. `xls`, `xlsx`) formats

**Metadata** : site metadata; mandatory columns include site name, coordinates, species, and link to *.rwl file with tree-ring width data of individual trees; format of the metadata file is `csv`

**Country borders** : ESRI shapefile `shp` with country borders in WGS-84 projection (alternatively, any other type of geographical information[^2] can be used)

[^1] `rwl` is standard format for storing tree-ring width data used by dendrochronological comunity. You can find details about this and other types of dendrochronological formats [here](https://www.treeringsociety.org/resources/SOM/Brewer_Murphy_SupplementaryMaterial.pdf).

[^2] E.g., administrative borders, rivers, urban districts, biogeographical regions, etc.
