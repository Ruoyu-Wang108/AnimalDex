# Define server logic required to plot various variables against mpg
shinyServer <- function(input, output, session) {
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
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
  
  ## filter the selected park
  parks <- eventReactive(input$tab2b, {
    nps_ca_five %>% 
      filter(unit_name %in% input$unit_name)
  })
  
  ## create the leaflet map of the selected park based on latitude and longitude boundary
   observeEvent(parks(), {
     leafletProxy("map", data = parks()) %>%
       #clearMarkerClusters() %>% 
       fitBounds(lng1 = ~long1, lng2 = ~long2, lat1 = ~parks()$lat1, lat2 = ~parks()$lat2 )
   })


  ## count the number of animal in the selected park

  animal_park <- eventReactive(input$tab2b, {
    park_animals %>% 
      dplyr::select(park, common_taxon) %>%  # narrow down the columns
      filter(park %in% input$unit_name) %>%  # filter based on the selected park
      count(common_taxon) 
  })
  
  ## make histogram of the animals in the selected park
  output$park_hist <- renderPlot({
    
      ggplot(data = animal_park(),
            aes(x = common_taxon, y = n)) +
        geom_col(aes(fill = common_taxon),
             show.legend = FALSE) +
        theme_minimal() +
        labs(x = " ",
           y = "How many animals are in your park?") +
        coord_flip()
  })

  
  
  # End For tab 2---------------------------------------
  
  
  # Tab 3-----------------------------------------------
  
  # Create the map
  output$map2 <- renderLeaflet({
    leaflet(nps_ca_five) %>%
    addProviderTiles(providers$Thunderforest.Outdoors) %>%
      addTiles(
        urlTemplate = "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=faa73f98b6a445298967f05e7a8908c4
",
        attribution = "&copy; <a href=\"http://www.thunderforest.com/\">Thunderforest</a>, {attribution.OpenStreetMap}",
        options = tileOptions(variant='outdoors', apikey = 'faa73f98b6a445298967f05e7a8908c4')
      ) %>%
      addPolygons(fill = FALSE, 
                  label = nps_ca_five$park) %>% 
      setView(lng = -119, lat = 37.5, zoom = 5.5)
  })
  
  
  # A reactive expression that returns the selected animal groups
  
  park_name <- eventReactive(input$tab2b,{
    park_animals_coords %>% 
    filter(park %in% input$unit_name)
})

  observeEvent(park_name(), {
    
    leafletProxy("map2", data = park_name()) %>%
      fitBounds(lng1 = ~min(park_name()$long1), lng2 = ~max(park_name()$long2), lat1 = ~min(park_name()$lat1), lat2 = ~max(park_name()$lat2))
  })
  


  # Create
  
  # Reactive data for animal groups  
  animals <- reactive({
    
    filter(park_name(), iconic_taxon_name == input$animal_type) 
    
  })

  # animals(), first filter result data frame
  # build up choices based on previous selection
  observeEvent(animals(),{
    updateSelectInput(session, 
                      "species", # inputId
                      choices = c("--Select--",
                                  unique(animals()$common_name)))
    
    leafletProxy("map2", data = animals()) %>%
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
    
    leafletProxy("map2", data = species()) %>%
      clearMarkerClusters() %>% 
      addMarkers(lng = ~X, lat = ~Y, 
                 clusterOptions = markerClusterOptions(),
                 label = species()$common_name)
  })
  

}