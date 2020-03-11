# Define server logic required to plot various variables against mpg
shinyServer <- function(input, output, session) {
  
  
 
  
  ## Interactive Map ###########################################
  
#   # Create the map
#   output$map <- renderLeaflet({
#     leaflet(nps_ca_five) %>%
#       addProviderTiles(providers$Thunderforest.Outdoors) %>% 
#       addTiles(
#         urlTemplate = "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=faa73f98b6a445298967f05e7a8908c4
# ",
#         attribution = "&copy; <a href=\"http://www.thunderforest.com/\">Thunderforest</a>, {attribution.OpenStreetMap}",
#         options = tileOptions(variant='outdoors', apikey = 'faa73f98b6a445298967f05e7a8908c4')
#       ) %>% 
#       addPolygons(fill = FALSE, 
#                   label = nps_ca_five$unit_name) %>% 
#       setView(lng = -119, lat = 37.5, zoom = 5.5)
#   })
  
  # California, Longitude: 36.7783° N, 119.4179° W
  
  
  # TAB 2---------------------------------------------
  # Reactive Data for parks
  
  ## filter the selected park
  parks <- reactive({
    nps_ca_five %>% 
      filter(unit_name %in% input$unit_name)
  })

  animal_type <- reactive({
    park_animals %>%
      dplyr::select(park, common_taxon) %>% 
      filter(park %in% input$unit_name)
  })
  
  ## create the leaflet map of the selected park based on latitude and longitude boundary
   ### Create color palette used for coloring of animal groups
  
    pal_animal <- reactive({
      leaflet::colorFactor(c("orange1", "turquoise3", "palevioletred1", "slateblue1"), animal_type()$common_taxon)
    })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Thunderforest.Outdoors) %>% 
      addTiles(
        urlTemplate = "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=faa73f98b6a445298967f05e7a8908c4",
        attribution = "&copy; <a href=\"http://www.thunderforest.com/\">Thunderforest</a>, {attribution.OpenStreetMap}",
        options = tileOptions(variant='outdoors', apikey = 'faa73f98b6a445298967f05e7a8908c4')
      ) %>% 
      addPolygons(data = parks(),
                  fill = FALSE, 
                  label = parks()$unit_name,
                  color = "#444444") %>% 
      addCircleMarkers(data = animal_type(),
                       color = ~pal_animal()(common_taxon),
                       opacity = 0.7,
                       weight = 0.9,
                       radius = 5)%>%
      addLegend(data = animal_type(),
                title = "Animal Group",
                pal = pal_animal(), 
                values = ~common_taxon, 
                opacity = 1)
   })


  ## count the number of animal in the selected park

  animal_park <- reactive({
    park_animals %>% 
      dplyr::select(park, common_taxon) %>%  # narrow down the columns
      filter(park %in% input$unit_name) %>%  # filter based on the selected park
      count(common_taxon) 
  })
  
  # create hyperlink to the website of the national parks that will be used in the introduction below
  yosemite_web <- a("office website", href="https://www.nps.gov/yose/index.htm")
  sequoia_web <- a("office website", href="https://www.visitsequoia.com/")
  joshua_web <- a("National Park Service Website", href="https://www.nps.gov/jotr/index.htm")
  death_web <- a("official website", href="https://www.nps.gov/deva/index.htm")
  channel_web <- a("official website", href = "https://www.nps.gov/chis/index.htm")
  
  # create output of park introduction based on chosen park
  ## use tagList to join text with hyperlink together
    output$park_intro <- renderUI({
    if(input$unit_name=="Yosemite National Park"){
    tagList("Yosemite National Park was established after the efforts 
             of John Muir and Robert Underwood Johnson on October 1st, 1864. Located in the western Sierra Nevada of Central California, 
             it covers an area of about 1169 mi2 (3029 km2) and is best known for its waterfalls along with deep valleys, spectacular rock, 
             grand meadows, giant sequoias, and peaceful lakes. With a snowy winter, pleasant spring and fall, and a hot summer, 
             the best time to visit Yosemite varies depending on what you plan to do, from hiking to birdwatching. You can visit their ", 
             yosemite_web, " for more information regarding campground reservations, lodging, dinning, and things to do.")
      }
    else
    if(input$unit_name=="Sequoia National Park") {
    tagList("Sequoia National Park was established on September 25, 1890 and protects 631 mi2 (1635 km2) of forested mountain at present. 
            Located in southern Sierra Nevada of California, it contains the highest point, Mount Whitney, 
            in the contiguous United States, which is 4421m above sea level. 
            Sequoia National Park is known for its giant sequoia trees. 
            General Sherman, estimated to be about 2,000 years old, is the largest single-stem tree by volume living on Earth. 
            You can visit their ", sequoia_web, " for more information regarding campground reservations, lodging, dinning, and things to do.")
    }
    else
    if(input$unit_name == "Joshua Tree National Park"){
      tagList("Joshua Tree National Park was originally declared as a national monument in 1936 
      but redesignated as a national park on October 31st, 1994. It is located in southeastern California, 
      east of Los Angeles and San Bernardino. This national park includes the higher Mojave Desert and 
      lower Colorado Desert, and encompasses a total of 1,235.4 mi2. The park was named after the 
      Joshua Tree (Yucca brevifolia), which are fast growing trees with deep and extensive root systems that can live 
      for hundreds of years. Although Joshua Tree National Park is located in the desert, there are many recreation 
      activities to do such as camping, hiking, and climbing. General visitor information can be found on 
      their official ", joshua_web, ".")
    }
    else
    if(input$unit_name=="Death Valley National Park"){
      tagList("Death Valley National Park was originally declared as a national monument in 1933 but was redesignated
      as a national park on October 31st, 1994. Located near east of the Sierra Nevada Mountains, Death Valley is the 
      largest national park in the contiguous United States (covering 5,270 mi2), and the hottest, driest and lowest of
      all the national parks in the United States. With an annual rainfall of less than two inches, a record high temperature 
      of 134°F, and 282 below sea level, animals observed here have adapted to this harsh environment. Although dangerous 
      and extreme, there are many scenic landscapes and views. Visit the National Park Service ", death_web, 
      " to learn more about this national park!")
    }
    else
    if(input$unit_name=="Channel Islands National Park"){
      tagList("Channel Island National Park was originally established as a national monument on April 26, 1938
      but was redesignated as a national park on March 5th, 1980. This national park includes 5 of 8 Channel 
      Islands located off the coast of Ventura, California. Channel Island National Park protects 388 mi2 of 
      land and 1,252 square nautical miles of ocean off the coastlines of the islands. There are many recreational 
      activities in this park including kayaking, scuba diving, and spearfishing available for visitors. 
      You can visit their ", channel_web, " to reserve camping, 
      make reservations for boat and plane transportation, and other general information.")
    }
    })  
  
    output$hist_title <- renderText({
    "How many animals are in the park?"
    })
  
  ## make histogram of the animals in the selected park
  output$park_hist <- renderPlot({
    
      ggplot(data = animal_park(),
            aes(x = common_taxon, y = n)) +
        geom_col(aes(color = common_taxon),
                fill = "white",
                show.legend = FALSE) +
        theme_minimal() +
        labs(x = " ",
             y = "") +
        scale_color_manual(values = c("orange1", "turquoise3", "palevioletred1", "slateblue1"))
        #+ coord_flip()
  })
  
  ## output park image based on selected park
    output$park_image<- renderImage({
    if(input$unit_name=="Sequoia National Park") Leg<-"www/sequoia.jpg"
    if(input$unit_name=="Channel Islands National Park") Leg<-"www/channel_island.jpg"
    if(input$unit_name=="Yosemite National Park") Leg<-"www/yosemite.jpg"
    if(input$unit_name=="Joshua Tree National Park") Leg<-"www/joshua_tree.jpg"
    if(input$unit_name=="Death Valley National Park") Leg<-"www/death_valley.jpg"
    list(src=Leg,
         width = 320)
  }, deleteFile = FALSE)  

  # End For tab 2---------------------------------------
  
  
  # Tab 3-----------------------------------------------
  
  # Create the map
  
  # A reactive expression that returns the selected animal groups
  
  # animals(), first filter result data frame
  observeEvent(input$animal_type, {  
    
    animals <- reactive({
    park_animals %>% 
      filter(park %in% input$unit_name,
             iconic_taxon_name == input$animal_type)
  })
  
  # build up choices based on previous selection

    updatePickerInput(session = session, 
                      "species", # inputId
                      choices = c(unique(animals()$common_name))
    )
  })    
 
  # species(), second result data frame
  species <- reactive({
    park_animals %>% 
      filter(park %in% input$unit_name,
             iconic_taxon_name %in% input$animal_type,
             common_name %in% input$species)
  })
  
  # create species color palette
  n_species <- reactive({
    length(input$species)
  })
  
  pal_species <- reactive({
    leaflet::colorFactor(c(rainbow(n = n_species(), s = 0.5)), species()$common_name)
  })
  
  
  # Reactive data for specie
    output$map2 <- renderLeaflet({
      leaflet() %>% 
        addProviderTiles(providers$Thunderforest.Outdoors) %>% 
        addTiles(
          urlTemplate = "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=faa73f98b6a445298967f05e7a8908c4",
          attribution = "&copy; <a href=\"http://www.thunderforest.com/\">Thunderforest</a>, {attribution.OpenStreetMap}",
          options = tileOptions(variant='outdoors', apikey = 'faa73f98b6a445298967f05e7a8908c4')
        ) %>%
        addPolygons(data = parks(),
                    fill = FALSE, 
                    label = parks()$unit_name,
                    color = "#444444") %>% 
        addCircleMarkers(data = species(),
                         color = ~pal_species()(common_name),
                         opacity = 2,
                         weight = 1,
                         radius = 7) %>%
        addLegend(data = species(),
                  title = "Species",
                  pal = pal_species(), 
                  values = ~common_name, 
                  opacity = 1)
})

  

}