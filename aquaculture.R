

aquaculture <- function(min_temp, max_temp, min_depth, max_depth){
  
  if (min_depth < 0 || max_depth < 0) {
    stop("Error: min_depth and max_depth must be non-negative numbers.")
  }
  
  species_temp <- mean_sst
  
  rcl_temp <- matrix(c(-Inf, min_temp, 0,
                       min_temp, max_temp, 1,
                       max_temp, Inf, 0), 
                     ncol = 3, byrow = TRUE)
  
  species_temp <- classify(species_temp, rcl = rcl_temp)
  
  species_temp <- as.factor(species_temp)
  
  species_depth <- elevation
  
  rcl_depth_fun <- matrix(c(-Inf, -max_depth, 0,
                            -max_depth, min_depth, 1,
                            min_depth, Inf, 0), 
                          ncol = 3, byrow = TRUE)
  
  species_depth <- classify(species_depth, rcl = rcl_depth_fun)
  
  species_depth <- as.factor(species_depth)
  
  species_territory <- (species_depth * species_temp)
  
  species_territory <- as.factor(species_territory)
  
  values(species_territory)[values(species_territory) == 0] <- NA
  
  eez <- st_transform(eez, crs = crs(species_territory))
  
  eez_raster_species <- rasterize(eez, species_territory, field = "rgn_id")
  
  species_territory <- (species_territory * eez_raster_species)
  
  species_territory <- project(species_territory, "EPSG:3395")
  
  cell_size <- res(species_territory)
  
  cell_area_m2 <- prod(cell_size)
  
  cell_area_km2 <- cell_area_m2 / 1000000
  
  value_counts_species <- freq(species_territory)
  
  value_counts_species$area_km2_s <- value_counts_species$count * cell_area_km2
  
  colnames(value_counts_species)[colnames(value_counts_species) == "value"] <- "rgn_id"
  
  region_info_species <- eez %>%
    st_drop_geometry()
  
  value_counts_species <- region_info_species %>%
    left_join(value_counts_species, by = "rgn_id") %>%
    dplyr::select(-area_m2, -area_km2, -layer, -rgn_key) %>%
    mutate(across(everything(), ~replace(., is.na(.), 0)))
  
  eez_species <- eez %>%
    left_join(value_counts_species, by = "rgn_id")
  
  eez_species$combined_labels <- paste(eez_species$rgn.y, eez_species$rgn_key, sep = "\n")
  
  species_table <- kableExtra::kable(value_counts_species, 
                                     format = "simple", 
                                     col.names = c("Region", 
                                                   "Region ID", 
                                                   "Cell Count", 
                                                   "Area, Km²"), 
                                     caption = "Suitable Cultivation Territory in West Coast EEZs",
                                     align = "l",
                                     digits = 2)
  
  tm_shape(elevation) +
    tm_raster(palette = palette, 
              breaks = breaks, 
              title = "Elevation (m)", 
              style = "fixed",
              alpha = 0.8,
              legend.show = FALSE) +
    tm_shape(eez_species) +
    tm_polygons(col = "area_km2_s",
                palette = "Greens",
                border.col = "#6A8EAE",
                lwd = 0.3,
                alpha = 0.9,
                title = expression("Suitable Area, Km"^2*"")) +
    tm_text("combined_labels", 
            size = 0.5, 
            col = "midnightblue", 
            shadow = FALSE, 
            auto.placement = FALSE) + 
    tm_layout(legend.text.size = 0.6,
              legend.width = 0.3,
              legend.position = c(0.72, 0.884),
              legend.bg.color = "seashell1",
              frame = TRUE,
              bg.color = "grey12",
              main.title = "West Coast EEZ Suitability for\nChosen Species Aquaculture",
              main.title.position = c("center", "top"),
              main.title.size = 1.2,
              inner.margins = c(0, 0, 0, 0),
              outer.margins = c(0, 0, 0, 0),
              asp = 0) +
    tm_scale_bar(text.color = "#F6EAC7",
                 color.dark = "#665A47",
                 color.light = "#F6EAC7",
                 position = c(0.07, 0.02),
                 width = 0.3) +
    tm_compass(type = "arrow",
               size = 1.5,
               position = c(0.06, 0.06),
               text.color = "#F6EAC7",
               color.dark = "#665A47",
               color.light = "#F6EAC7") 
  
  
}

