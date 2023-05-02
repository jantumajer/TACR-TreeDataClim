# Modified version of the VS-Lite process-based model of wood formation 

The model is based on the VS-Lite model originaly published by (Dr. Tolwinski-Ward)[https://www.suztw.com/]. The VS-Lite is a simple process-based model of wood formation assuming that intra-annual radial growth rate is non-linearly dependent on temperature, soil moisture, and photoperiod. In a framework of the TreeDataClim project, we used the model to calculate the intensity of climatic limitation of wood formation at each site in a monthly scale.

### Principles of the VS-Lite model
The detailed description of the VS-Lite workflow is provided in a publication of Tolwinski-Ward et al. (2011). The approach used for an assessment of the intensity of various types of climate-growth limitation for annual wood formation at given site is provided in Tumajer et al. (2017).

### Modifications to the original VS-Lite model
To improve applicability of the VS-Lite model in cold and wet environments, which was shown insufficient (Breitenmoser et al. 2014), we modified the response functions of the model. Specifically, we incorporated an assumption of an optinal limitation of radial growth by too high soil moisture and too high temperature.

### Aplicability
To calibrate the model, run `Skript_RUN.m` function in Octave. The function will authomatically load `estimate_randomization_decline.m` script to generate a large number of random combinations of the model parameters. Next, the script will store the set of parameters resulting in a highest correlation between the simulated and observed chronologies. With this set of parameters, the full model is calibrated and various types of results are stored using `VSLite_decline.m`

### References
*Breitenmoser, P., Brönnimann, S., Frank, D., 2014. Forward modelling of tree-ring width and comparison with a global network of tree-ring chronologies. Climate of the Past 10, 437–449. https://doi.org/10.5194/cp-10-437-2014*

*Tolwinski-Ward, S.E., Evans, M.N., Hughes, M.K., Anchukaitis, K.J., 2011. An efficient forward model of the climate controls on interannual variation in tree-ring width. Climate Dynamics 36, 2419–2439. https://doi.org/10.1007/s00382-010-0945-5*

*Tumajer, J., Altman, J., Štěpánek, P., Treml, V., Doležal, J., Cienciala, E., 2017. Increasing moisture limitation of Norway spruce in Central Europe revealed by forward modelling of tree growth in tree-ring network. Agricultural and Forest Meteorology 247, 56–64. https://doi.org/10.1016/j.agrformet.2017.07.015*
