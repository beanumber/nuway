## code to prepare `DATASET` dataset goes here

library(tidyverse)

# http://northamptonma.gov/DocumentCenter/View/13270/lots_20190816

library(sf)

# lots <- read_sf(here::here("data-raw/lots_20190816/"))

nu_way <- read_delim("data-raw/nu_way.tsv", delim = "\t") %>%
  mutate(date = lubridate::mdy(`Rec. Date`)) %>%
  rename(address = `Street #`)

properties <- nu_way %>%
  group_by(address) %>%
  summarize(
    n(), 
    begin = min(date),
    end = max(date)
  )

library(sf)
library(tidygeocoder)

nu_way_zillow <- read_csv("data-raw/nu_way_zillow.csv")

nu_way_sf <- properties %>%
  filter(str_detect(address, "^[0-9]")) %>%
  filter(!str_detect(address, "0 ROUND HILL RD")) %>%
  mutate(lkup = paste(address, "Northampton, MA 01060")) %>%
  geocode(lkup, method = "osm") %>%
  st_as_sf(coords = c("long", "lat")) %>%
  st_set_crs(4326)




#handzel <- lots %>%
#  inner_join(nu_way, by = c("OwnAdd" = "address")) %>%
#  st_transform(4326)


library(leaflet)
leaflet() %>%
  addTiles() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>%
  addMarkers(data = nu_way_sf, popup = ~address)
  


usethis::use_data(nu_way_sf, overwrite = TRUE)
