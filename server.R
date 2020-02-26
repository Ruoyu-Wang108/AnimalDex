# Define server logic required to plot various variables against mpg
shinyServer <- function(input, output, session) {
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$basemap <- renderLeaflet({
    leaflet(nps_ca_five) %>%
      addProviderTiles(providers$Stamen.Terrain) %>% 
      addPolygons(fill = FALSE, 
                  popup = nps_ca_five$unit_name) %>% 
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

  
  
  # Reactive data for animal groups  
  animals <- reactive({
    park_animals %>% 
    dplyr::select(common_name, iconic_taxon_name, park) %>% 
    filter(iconic_taxon_name == input$animal_type) 
    
  })

  
  # build up choices based on previous selection
  observeEvent(animals(),{
    updateSelectInput(session, 
                      "species", # inputId
                      choices = unique(animals()$common_name))
  })
  
  
  # Reactive data for species
  species <- reactive({
    filter(animals(), common_name == input$species)
  })
  
  
  # observe({
  #   #group <- animals()
  # 
  #   leafletProxy("basemap", data = animals()) %>%
  #     addMarkers(icon = animals()$iconic_taxon_name)
  # })
  
  
  
  
  
  
  
}