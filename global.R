# Attach packages
library(shiny)
library(tidyverse)
library(kableExtra)
library(shinythemes)
library(here)
library(janitor)
library(paletteer)
library(raster)
library(sf)
library(tmap)
library(leaflet)
library(ggplot2)



# Read in data

## read in national parks boundaries

nps <- read_sf(dsn = here("data", "National_Park_Service__Park_Unit_Boundaries"), 
               layer = "National_Park_Service__Park_Unit_Boundaries", crs = 4326) %>% 
  clean_names()

nps_ca <- nps %>% 
  filter(state == "CA")

nps_ca_five <- nps_ca %>% 
  filter(unit_name %in% c("Death Valley National Park", "Joshua Tree National Park", "Yosemite National Park", "Channel Islands National Park", "Sequoia National Park")) %>% 
  dplyr::select(unit_name)

#plot(nps_ca_five)

# Read in park data

# Channel islands

channel_islands <- read_csv(here::here("data", "Animals", "channel_islands.csv")) %>% 
  dplyr::select(latitude, longitude, common_name, iconic_taxon_name) %>% 
  mutate(iconic_taxon_name = as.character(iconic_taxon_name)) %>% 
  filter(!iconic_taxon_name %in% c("Actinopterygii", "Animalia")) %>% 
  mutate(park = "Channel Islands National Park")

channel_islands_sf <- st_as_sf(channel_islands, 
                               coords = c("longitude", "latitude"), 
                               crs = 4326)


# Death Valley

death_valley <- read_csv(here::here("data", "Animals", "death_valley.csv")) %>% 
  dplyr::select(latitude, longitude, common_name, iconic_taxon_name) %>% 
  filter(!iconic_taxon_name == "Animalia") %>% 
  mutate(park = "Death Valley National Park")

death_valley_sf <- st_as_sf(death_valley,
                            coords = c("longitude", "latitude"),
                            crs = 4326)

# Joshua Tree

joshua_tree <- read_csv(here::here("data", "Animals", "joshua_tree.csv")) %>% 
  dplyr::select(latitude, longitude, common_name, iconic_taxon_name) %>% 
  filter(!iconic_taxon_name %in% c("Animalia", "Plantae")) %>% 
  mutate(park = "Joshua Tree National Park")

joshua_tree_sf <- st_as_sf(joshua_tree,
                           coords = c("longitude", "latitude"),
                           crs = 4326)
# Yosemite

yosemite <- read.csv(here("data", "Animals", "yosemite.csv")) %>% 
  clean_names()

yosemite_clean <- yosemite %>% 
  dplyr::select(longitude, latitude, common_name, iconic_taxon_name) %>% 
  mutate(iconic_taxon_name = as.character(iconic_taxon_name)) %>% 
  filter(iconic_taxon_name != "Animalia") %>% 
  mutate(park = "Yosemite National Park")

yosemite_sf <- st_as_sf(yosemite_clean, coords = c("longitude", "latitude"),
                        crs = 4326)

# Sequoia

sequoia <- read.csv(here("data", "Animals", "sequoia.csv")) %>% 
  clean_names()

sequoia_clean <- sequoia %>% 
  dplyr::select(longitude, latitude, common_name, iconic_taxon_name) %>% 
  mutate(iconic_taxon_name = as.character(iconic_taxon_name)) %>% 
  mutate(park = "Sequoia National Park")

sequoia_sf <- st_as_sf(sequoia_clean, coords = c("longitude", "latitude"),
                       crs = 4326)


# join species observations data

animal <- rbind(channel_islands_sf, death_valley_sf, yosemite_sf, sequoia_sf, joshua_tree_sf)

# ONLY keep animal points inside the polygons
park_animals <- st_join(animal, nps_ca_five, left = FALSE)