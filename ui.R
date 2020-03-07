animal_group <- c(
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
                        selectInput(inputId = "unit_name", 
                                    label = "Choose a Park!",
                                    choices = c("--Select--",
                                                unique(nps_ca_five$unit_name))),
                        # action button
                        actionButton("tab2b", "Your Park", class = "btn-primary"),
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
        
        # Basemap with park outlines
        leafletOutput("map2", width = "100%", height = 600),
        
        # ------absolute panel------------
        # Might need html/css to change the background and color of this panel
        absolutePanel(id = "controls",
                      #class = "panel panel-default",
                      fixed = TRUE,
                      draggable = TRUE,
                      top = 250,
                      left = 40,
                      #right = 33, 
                      #bottom = "auto",
                      width = 210, 
                      #height = "auto",

                      h3(img(src="move_icon.png", height = 40, width = 25),"Animals explorer"),

                      # selectInput(inputId = "park_type",
                      #             label = "Select your destination",
                      #             choices = c(unique(park_animals$park))
                      #             ),
                      
                      # Select the animal types
                      radioButtons(inputId = "animal_type", 
                                   label = "Animal Types",
                                   choices = animal_group),
                      
                      # selectInput(inputId = "animal_type", 
                      #             label = "Animal Types",
                      #             choices = c(unique(animal$iconic_taxon_name))
                      #             ),
                      
                      
                      
                      # select the specices
                      selectInput(inputId = "species",
                                  label = "Animal Specices",
                                  choices = NULL
                                    ),
                      
                      p("After selecting the species, click:"),
                      
                      actionButton("action1", "Observe", class = "btn-primary")
                      # Not sure what this does
                      #conditionalPanel("input.animal_type == 'Ave' || input.species == 'Allen's Hummingbird")

        )
        #------ END absulute panel ----------------------
        
        
      )
      # -------END Tab 3---------------
      
      
    )

# ---------END Navbar-------------------
 
 
  )
# -------END Fluid page-----------------
  
)
# =========END APP======================