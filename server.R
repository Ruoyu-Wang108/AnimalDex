# Define server logic required to plot various variables against mpg
shinyServer <- function(input, output, session) {
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$basemap <- renderLeaflet({
    leaflet(nps_ca_five) %>%
      addProviderTiles(providers$Stamen.Terrain) %>% 
      addPolygons(fill = FALSE) %>% 
      setView(lng = -119, lat = 37.5, zoom = 5.5)
  })
  
  # California, Longitude: 36.7783° N, 119.4179° W
  
  # A reactive expression that returns the selected animal groups
  
  
  
  
  
  
  
  
  
  
  
  
}