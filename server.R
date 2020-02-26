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
  
  # unworking codes ----------------------------------------------
  
  # park_name <- reactive ({
  #   req(input$park_type)
  #   if(input$park_type == "NA") {
  #     filter(park_animals, is.na(park))
  #   } else {
  #     filter(park_animals, park == input$park_type)
  #   }
  # })
  # 
  # observeEvent(park_name(), {
  #   taxon <- unique(park_name()$iconic_taxon_name)
  #   updateSelectInput(session, "animal_type", choices = taxon)
  # })
  # Not working yet --------------------------------------------
  
  animals <- reactive({
    filter(park_animals, iconic_taxon_name == input$animal_type)
  })

  observeEvent(animals(),{
    updateSelectInput(session, "species", choices = unique(animals()$common_name))
  })
  
  
  
  
  
  
  
  
  
  
  
}