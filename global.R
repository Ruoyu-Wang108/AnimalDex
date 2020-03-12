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
library(shinyWidgets)



# Read in data

## read in national parks boundaries

nps <- read_sf(dsn = here("data", "National_Park_Service__Park_Unit_Boundaries"), 
               layer = "National_Park_Service__Park_Unit_Boundaries", crs = 4326) %>% 
  clean_names()

nps_ca <- nps %>% 
  filter(state == "CA")

nps_ca_five <- nps_ca %>% 
  filter(unit_name %in% c("Death Valley National Park", "Joshua Tree National Park", "Yosemite National Park", "Channel Islands National Park", "Sequoia National Park")) %>% 
  dplyr::select(unit_name) %>% 
  mutate(lat1 = c(36.2 , 33.3, 37.5, 33.5, 35.6), 
         lat2 = c(36.8 , 34.5, 38.2, 34.3, 37.4),
         long1 = c(-119 , -120.6, -120, -116.7, -118.1),
         long2 = c(-118.2 , -119, -119.1, -115, -116.2))


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

# ONLY keep *animal points* inside the polygons
park_animals <- st_join(animal, nps_ca_five, left = FALSE) %>% 
  filter(!common_name %in% c("Birds", "Mammals", "Reptiles", "Snakes", "Amphibians", "NA", "Lizards", "Ensatina",
                             "Frogs and Toads", "Rodents", "Tree Squirrels", "Typical Squirrels", "Canines", "Squamates"))

# change island fox to santa cruz island fox
park_animals$common_name[park_animals$common_name == "Island Fox"] <- "Santa Cruz Island Fox"

# change western side-blotched lizard to common side-blotched lizard
park_animals$common_name[park_animals$common_name == "Western Side-blotched Lizard"] <- "Common Side-blotched Lizard"

# change western sagebrush lizard to common sagebrush lizard
park_animals$common_name[park_animals$common_name == "Western Sagebrush Lizard"] <- "Common Sagebrush Lizard"



taxon_to_common <- data.frame(iconic_taxon_name = unique(park_animals$iconic_taxon_name),
                              common_taxon = c("Birds", "Mammals", "Reptiles", "Amphibians"))

park_animals <- park_animals %>% 
  full_join(taxon_to_common)

# Also get the lat & long for the animal observations, lon - X, lat - Y
park_animals_coords <- data.frame(park_animals,
                                  sf::st_coordinates(park_animals)) 
