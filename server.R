# Define server logic required to plot various variables against mpg
shinyServer <- function(input, output, session) {
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$basemap <- renderLeaflet({
    leaflet(nps_ca_five) %>%
      addProviderTiles(providers$Thunderforest.Outdoors) %>% 
      addTiles(
        urlTemplate = "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=faa73f98b6a445298967f05e7a8908c4
",
        attribution = "&copy; <a href=\"http://www.thunderforest.com/\">Thunderforest</a>, {attribution.OpenStreetMap}",
        options = tileOptions(variant='outdoors', apikey = 'faa73f98b6a445298967f05e7a8908c4')
      ) %>% 
      addPolygons(fill = FALSE, 
                  label = nps_ca_five$unit_name) %>% 
      setView(lng = -119, lat = 37.5, zoom = 5.5)
  })
  
  # California, Longitude: 36.7783° N, 119.4179° W
  
  
  # TAB 2---------------------------------------------
  # Reactive Data for parks
  parks <- reactive ({
    nps_ca_five %>% 
      filter(unit_name %in% input$unit_name)
  })
  
  # Output ggplot map
  # PROBLEM: Not able to filter animal points by park boundary
  # SOLUTION: 1.) Combine BOTH nps_ca_five + park_animals AS ONE sf?
  #           2.) Add another widget for park_animals
  output$park_plot <- renderPlot({
    
    ggplot(data = parks()) +
      geom_sf(fill = "white") +
      geom_sf(data = park_animals,
              aes(color = iconic_taxon_name),
              alpha = .5)
    
  })
  
  # Output ggplot histogram
  # Problem: Doesn't work LOL and would only have total animal counts for each park
  output$park_hist <- renderPlot({
    
    ggplot(data = parks()) +
      geom_histogram(data = park_animals,
                     aes(x = iconic_taxon_name))
  })
  
  # End For tab 2---------------------------------------
  
  
  # Tab 3-----------------------------------------------
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
    park_animals_coords %>% 
    #dplyr::select(common_name, iconic_taxon_name, park) %>% 
    filter(iconic_taxon_name == input$animal_type) 
    
  })

  # animals(), first filter result data frame
  # build up choices based on previous selection
  observeEvent(animals(),{
    updateSelectInput(session, 
                      "species", # inputId
                      choices = c("--Select--",
                                  unique(animals()$common_name)))
    
    leafletProxy("basemap", data = animals()) %>%
      clearMarkerClusters() %>% 
      addMarkers(lng = ~X, lat = ~Y, label = ~common_name, 
                 clusterOptions = markerClusterOptions())
  })
  
  
  # species(), second result data frame
  # Reactive data for species
  species <- reactive({
    filter(animals(), common_name == input$species)
  })
  
  
  observeEvent(input$action1,{
    
    leafletProxy("basemap", data = species()) %>%
      clearMarkerClusters() %>% 
      addMarkers(lng = ~X, lat = ~Y, 
                 clusterOptions = markerClusterOptions(),
                 label = species()$common_name)
  })
  

}