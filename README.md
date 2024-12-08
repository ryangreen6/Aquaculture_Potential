# Exploring Aquaculture Potential on the West Coast of North America

Marine aquaculture has the potential to significantly contribute to the global food supply, offering a more sustainable protein source compared to conventional land-based meat production. 

The purpose of this repository is to determine which Exclusive Economic Zones (EEZs) on the West Coast of the US are most suitable for marine aquaculture. The majority of the code examines the EEZ suitability for Oysters and Pacific Herring. Additionally, a function called `aquaculture` was created to apply the same steps to any marine species desired. Suitable locations are determined by bathymetry and by average sea surface temperatures. 



## Within this repository:

- Aquaculture_Potential.rproj
- Aquaculture_Potential.qmd
- aquaculture.R
- README.md
- .gitignore

## Data
The data for this analysis is not included in this repository. 

- Sea Surface Temperature (SST) - Five rasters of SST (years 2008-2012) were aggregated to provide a recent average SST for the West Coast. The data was originally generated from NOAA’s 5km Daily Global Satellite Sea Surface Temperature Anomaly v3.1. The data can be downloaded here: https://coralreefwatch.noaa.gov/product/5km/index_5km_ssta.php

- Bathymetry - Ocean depth was characterized using data from General Bathymetric Chart of the Oceans (GEBCO). The data can be downloaded here: https://www.gebco.net/data_and_products/gridded_bathymetry_data/#area

- Exclusive Economic Zones (EEZs) - Marine boundaries for EEZs are available as shapefiles from Marineregions.org. The data can be downloaded here: https://www.marineregions.org/eez.php


## Acknowledgements
This project was a part of my learning process in the Bren School's MEDS program at UCSB. I'd like to recognize any and all professors and teacher's assistants who guided me along the way. 

MEDS Program, UCSB: https://bren.ucsb.edu/masters-programs/master-environmental-data-science

## References

Hall, S. J., Delaporte, A., Phillips, M. J., Beveridge, M. & O’Keefe, M. Blue Frontiers: Managing the Environmental Costs of Aquaculture (The WorldFish Center, Penang, Malaysia, 2011).
