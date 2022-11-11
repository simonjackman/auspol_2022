########################################################
## find SA1s that straddle multiple CEDs
##
## simon jackman
##
##
## 2022-10-23 19:58:53.994739
########################################################

library(tidyverse)
library(here)
library(sf)
library(leaflet)

## sa1 shp
##sa1_shp <- st_read(here("../data/census/geography/SA1_2021_AUST_SHP_GDA2020/SA1_2021_AUST_GDA2020.shp"))
sa1_shp <- st_read(here("../data/census/geography/1270055001_sa1_2016_aust_shape/SA1_2016_AUST.shp"))
sa1_shp$ccd_id <- sa1_shp$SA1_7DIG16

## ced shp
ced_shp <- rgdal::readOGR(dsn = here("../../../HubSpot migration/aux_data/2021-Cwlth_electoral_boundaries_ESRI"))
ced_shp <- as(ced_shp, "sf") %>% st_transform(crs=st_crs(sa1_shp))

## SA1s crossing CED
##sa1_cross <- sa1_shp %>% st_intersects(ced_shp)
##sa1_shp$ceds <- unlist(lapply(sa1_cross,length))

## look at CED with SA1 splits on border

mapFunction <- function(theDivision) {
  theMap <- ced_shp %>% filter(Elect_div == theDivision)
  epsg7844 <- leafletCRS(code = "EPSG:7844",
                         proj4def = "+proj=longlat +datum=WGS84 +ellps=GRS80 +no_defs +type=crs")

  m <- leaflet(theMap,
               options = leafletOptions(crs = epsg7844)) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(
      opacity = 0.10,
      fill = gray(.50),
      stroke = TRUE,
      color = "blue",
      weight = 3
    )

  ## overlapping sa1
  theOverlaps <- sa1_shp %>%
    semi_join(
      sa1 %>%
        filter(div_nm == theDivision) %>%
        distinct(ccd_id) %>%
        mutate(ccd_id = as.character(ccd_id)),
      by = "ccd_id"
    )

  print(theOverlaps)

  #theOverlaps_shp <- setdiff(unlist(st_overlaps(theMap,
  #                                              sa1_shp)),
  #                           unlist(st_covers(theMap,
  #                                            sa1_shp)))

  #theOverlaps_shp <- sa1_shp %>%
  #  slice(theOverlaps_shp)

  m <- m %>%
    addPolygons(
      data = theOverlaps,
      label = theOverlaps$ccd_id,
      stroke = TRUE,
      color = "red",
      weight = 1,
      fill = FALSE
    )

  return(m)
}

mapFunction("La Trobe")
mapFunction("Wentworth")
mapFunction("Dickson")
