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




# Read in data

## read in national parks boundaries

nps <- read_sf(dsn = here("data", "National_Park_Service__Park_Unit_Boundaries"), 
               layer = "National_Park_Service__Park_Unit_Boundaries", crs = 4326) %>% 
  clean_names()

nps_ca <- nps %>% 
  filter(state == "CA")

nps_ca_five <- nps_ca %>% 
  filter(unit_name %in% c("Death Valley National Park", "Joshua Tree National Park", "Yosemite National Park", "Channel Islands National Park", "Sequoia National Park")) %>% 
  select(unit_name)

plot(nps_ca_five)
