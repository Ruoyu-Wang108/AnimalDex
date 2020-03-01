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
        sidebarPanel(
          "national park pics"
        ),
        mainPanel(
          "Some overall introduction of the app"
        )
      ),
      # ------END Tab 1----------------
      
      # -------Tab 2-------------------
      tabPanel(
        "Park",
        
        fluidRow(column(4, algin = "center",
                        selectInput(inputId = "unit_name", 
                                    label = "Choose a Park!",
                                    choices = c("--Select--",
                                                unique(nps_ca_five$unit_name))),
                        actionButton("tab2b", "Your Park", class = "btn-primary"),
                        plotOutput(outputId = "park_hist")
                        ),
                 
                 column(8, 
                        leafletOutput("map", width = "100%", height = 500),
                        p("this is park introduction")
                        )
                 )
      
        
      ),
      # -------END Tab 2----------------
      
      
      
      
      # -------Tab 3--------------------
      tabPanel(
        "Animals",
        
        # Basemap with park outlines
        #leafletOutput("map", width = "100%", height = 600),
        
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