# Assessment of growth trends in basal area increment #

The analysis of the main growth trends of tree species is based on the trends in the Basal area increment (BAI). Time series of BAI might be considered as a suitable proxy for stem biomass increments (Bošel’a et al., 2023). To calculate BAI from tree-ring width series for each tree, an R package dplR is used (Bunn, 2010) (Figure 1A,B). 

The function `prepare.dataset` creates a data frame used in further steps of the modelling.

To account for ontogenetical trends in growth series, BAI values for individual trees and years were simulated using a generalized additive mixed effect model (GAMM) with predictors of cumulative basal area (BA; cumulative sums of basal area increments of each tree), cambial age and their interaction  (Figure 1C,D). GAMMs were calibrated using package mgcv (Wood et al. 2011). Both predictors were included as thin plate regression smoothing terms. Therefore, the final formula was: BAIi,j~s(BAij)+s(CambialAgeij)+s(BAij):s(CambialAgeij), where i refers to the tree and j refers to the year. Models for all sites can be calibrated using the function `calculate.models`. This function serves as a for-loop for a function `calculate.model` parameterizing GAMM for one specific site. The function is called separately for each site and each tree from a given site is included as a random effect (Figure 1E). Only sites with n>=5 trees are included in the calculations.

To get representative results of the current growth trend, the final model is predicted for the so-called “representative tree”, which is a median tree at given plot (tree of median age and BA – basal area; Figure 1C,D). Such a tree is calculated using  functions `create.mean.tree` for a single site or `create.mean.trees` for all sites within the dataset (implicitly calculated for sites with n>=5 trees).

The BAI is predicted using the parameterized GAMM models for each site for a specified period (the default period is 1990-2022, in the case of our study in preparation we consider the 1990-2014 period) (Figure 1F). To aid the comparison of BAI series between sites with different age structures and growth rates, the fitted BAI for representative trees in the period of 1990-2014 can be standardized using a few different approaches: (i) by mean BAI predicted for the previous 30-years long period at a given site (in case of our study 1960 – 1989; Figure 1F); (ii) by mean BAI in the period (in case of our study 1990-2014); (iii) normalizing data to get the range from 0-1; (iv) or scaling the data to get a unit variance and mean of zero.

![Figure_1](https://github.com/jantumajer/TACR-TreeDataClim/assets/25429975/07e0491b-fdd7-4626-8e21-4203c7510f30)


**Figure 1**: Methodological approach of calculation representative basal area increment (BAI) for a single site. A - BAI of all trees in the study; B - the subset of BAI from one site (5 trees from site "C004022PISY"); C - BA of subset trees; D - cambial age in the sampling point; E - fitted BAI of individual trees and representative tree by GAM (dark grey area represents standardization period 1960-1989, a light grey area highlighted by a black line represents the period 1990-2014); F - fitted BAI of the representative tree, standardized by the mean value in 1960-1989; G - example of fitted and standardized BAI of 5 representative trees of 5 pine sites.

**References**

*Bošel’a, M., Rubio-Cuadrado, Á., Marcis, P., Merganičová, K., Fleischer, P., Forrester, D. I., Uhl, E., Avdagić, A., Bellan, M., Bielak, K., Bravo, F., Coll, L., Cseke, K., del Rio, M., Dinca, L., Dobor, L., Drozdowski, S., Giammarchi, F., Gömöryová, E., … Tognetti, R. (2023). Empirical and process-based models predict enhanced beech growth in European mountains under climate change scenarios: A multimodel approach. Science of The Total Environment, 888, 164123. https://doi.org/10.1016/j.scitotenv.2023.164123*

*Bunn, A. G. (2010). Statistical and visual crossdating in R using the dplR library. Dendrochronologia, 28(4), 251–258. https://doi.org/10.1016/j.dendro.2009.12.001*

*Wood, S. N. (2011). Fast stable restricted maximum likelihood and marginal likelihood estimation of semiparametric generalized linear models. Journal of the Royal Statistical Society: Series B (Statistical Methodology), 73(1), 3–36. https://doi.org/10.1111/j.1467-9868.2010.00749.x*

