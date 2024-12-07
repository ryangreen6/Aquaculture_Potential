

aquaculture <- function(min_temp, max_temp, min_depth, max_depth){
  # Establish temperature reclassification matrix
  rcl_temp_fun <- matrix(c(-Inf, min_temp, NA,
                           min_temp, max_temp, 1,
                           max_temp, Inf, NA),
                         ncol = 3, byrow = TRUE)
  
  # Reclassify temperature raster using matrix
  function_temp <- classify(mean_sst, rcl = rcl_temp_fun)
  
  # Establish depth reclassification matrix
  rcl_depth_fun <- matrix(c(-Inf, min_depth, NA,
                            min_depth, max_depth, 1,
                            max_depth, Inf, NA),
                          ncol = 3, byrow = TRUE)
  
  # Reclassify depth raster using matrix
  function_depth <- classify(elevation, rcl = rcl_depth_fun)
  
  # Find suitable area for our chosen species
  species_territory <- lapp(c(function_temp, function_depth), fun = "*")
  
  species_territory <- project(species_territory, "EPSG:3395")
  
  cell_size <- res(species_territory)
  
  cell_area_m2 <- prod(cell_size)
  
  cell_area_km2 <- cell_area_m2 / 1000000
  
  value_counts_function <- freq(species_territory)
  
  value_counts_function$area_km2_h <- value_counts_function$count * cell_area_km2
  
  colnames(value_counts_function)[colnames(value_counts_function) == "value"] <- "rgn_id"
  
  region_info <- eez %>%
    st_drop_geometry()
  
  value_counts_function <- region_info %>%
    left_join(value_counts_function, by = "rgn_id") %>%
    dplyr::select(-area_m2, -area_km2, -layer, -rgn_key) %>%
    mutate(across(everything(), ~replace(., is.na(.), 0)))
  
  eez_all <- eez_all %>%
    left_join(value_counts_function, by = "rgn_id")
  
  kableExtra::kable(value_counts_function, 
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
    tm_shape(eez_function) +
    tm_polygons(col = 'area',
                border.col = "#6A8EAE",
                lwd = 0.3,
                alpha = 0.9,
                title = expression("Suitable Area, Km"^2*"")) +
    tm_layout(legend.text.size = 0.6,
              legend.width = 0.3,
              legend.position = c(0.72, 0.884),
              legend.bg.color = "seashell1",
              frame = TRUE,
              bg.color = "grey12",
              main.title = "West Coast EEZ Suitability for\nHerring Aquaculture",
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

