## code to prepare `DATASET` dataset goes here

library(tidyverse)

# http://northamptonma.gov/DocumentCenter/View/13270/lots_20190816

library(sf)

lots <- read_sf(here::here("data-raw/lots_20190816/"))

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

nu_way_zillow <- read_csv("data-raw/nu_way_zillow.csv")



handzel <- lots %>%
  inner_join(nu_way, by = c("OwnAdd" = "address")) %>%
  st_transform(4326)


library(leaflet)
leaflet() %>%
  addTiles() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>%
  addPolygons(data = nu_way_zillow, popup = ~OwnAdd)
  


usethis::use_data(DATASET, overwrite = TRUE)
