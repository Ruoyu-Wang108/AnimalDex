animal_group <- c(
  #"None selected" = "",
  "Birds" = "Aves",
  "Mammals" = "Mammalia",
  "Reptiles" = "Reptilia",
  "Amphibians" = "Amphibia"
)

shinyUI(
# ----------Fluid page-----------------  
  fluidPage(
    
    # change some style, but not sure if this is helpful...
    tags$style(type = "text/css", "html, body {width: 100%;height:100%}"), 
    
# ---------Overall Title---------------
  titlePanel("AnimalDex"),
# ---------END title-------------- ---- 
    
# --------Navigate bar-----------------
    navbarPage(
      
      theme = shinytheme("journal"),
      "Enjoy your trip with Animals finder",
      
      # -----Tab 1---------------------
      tabPanel(
        "Introduction",
        mainPanel(
          h4("Introduction of the App:", align = "left"),
          p("Welcome to AnimalDex! AnimalDex is an app that allows users to explore observed animals at 5 national parks: Channel Islands, Death Valley, Joshua Tree, Sequoia, and Yosemite. In the Park tab, users can select individual national parks to learn about its background information and geographic boundaries, and visualize which animal group (amphibians, birds, mammals, and reptiles) is most observed at the park. Once a park is selected, users are able to go into the Animals tab to select which animal type or species was observed at the national park. The goal of this app is to allow users to locate previous animal sightings and to increase likeliness of finding specific animals in the wild. Enjoy the app and find them all!"),
          h4("Data Summary:", align = "left"),
          p("Boundaries of the 5 national parks were downloaded from the",
          a("National Park Service Open Data ArcGIS", href = "https://public-nps.opendata.arcgis.com/"), 
          "website. Data of the animal observations were downloaded from the",
          a("iNaturalist Observation", href = "https://www.inaturalist.org/observations"),
          "page. Animal observations were then filtered by animal groupings and park boundaries. Interactive maps were created by the leaflet package using the",
          a("Thunderforest Outdoors", href = "https://www.thunderforest.com/maps/outdoors/) layer."),
          "layer."
      ),
        )
),
      # ------END Tab 1----------------
      
      # -------Tab 2-------------------
      tabPanel(
        "Park",
        
        fluidRow(column(3, algin = "center",
                        # select park
                        h4("Choose a Park!"),
                        selectInput(inputId = "unit_name", 
                                    label = "",
                                    choices = c(unique(nps_ca_five$unit_name))),
                        
                        # add a break line
                        p(" "),
                        p(" "),
                        # histogram of how many animals are in the selected park 
                        textOutput("hist_title"),
                        plotOutput(outputId = "park_hist", height = 400)
                        ),
                 column(4, algin = "center",
                        # park introduction
                        uiOutput("park_intro"),
                        # add a break line
                        p(" "),
                        p(" "),
                        # park image
                        imageOutput("park_image")),
                 column(5, 
                        # interactive park map
                        leafletOutput("map", width = "100%", height = 540)
                        )
                 )
      
        
      ),
      # -------END Tab 2----------------
      
      
      
      
      # -------Tab 3--------------------
      tabPanel(
        "Animals",
        
        fluidRow(column(3, algin = "center",
                        # select park
                        h3("Animal Types"),
                        radioButtons(inputId = "animal_type", 
                                     label = "",
                                     choices = animal_group),
                        # add a break line
                        p(" "),
                        p(" "),
                      
                        # select the specices
                        h3("Animal Specices"),
                        pickerInput(inputId = "species",
                                    label = "",
                                    choices = NULL, 
                                    multiple = TRUE,
                                    options = pickerOptions(
                                      actionsBox = TRUE,
                                      title = "Please select a species",
                                      style = "string",
                                      container = "string",
                                      dropupAuto = FALSE
                                    )
                        ),
                        
                        actionButton("action1", "Observe", class = "btn-primary")
                        ),
                        
                 column(9, algin = "center",
                        leafletOutput("map2", width = "100%", height = 500)
                        ),
                 )
        )
      # -------END Tab 3---------------
      
      
    )

# ---------END Navbar-------------------
 
 
  )
# -------END Fluid page-----------------
  
)
# =========END APP======================