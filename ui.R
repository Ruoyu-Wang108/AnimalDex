shinyUI(
# ----------Fluid page-----------------  
  fluidPage(
    
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
        sidebarPanel(
          "Select your destination:, or Here is the national park pics"
        ),
        mainPanel(
          "here is the map including facilities and statistic outcomes"
        )
      ),
      # -------END Tab 2----------------
      
      
      
      
      # -------Tab 3--------------------
      tabPanel(
        "Animals",
        
        # Basemap with park outlines
        leafletOutput("basemap", width = "100%", height = 600),
        
        # ------absolute panel------------
        # Might need html/css to change the background and color of this panel
        absolutePanel(id = "controls",
                      class = "panel panel-default",
                      fixed = TRUE,
                      draggable = TRUE,
                      top = 155,
                      left = "auto",
                      right = 33, bottom = "auto",
                      width = 320, height = "auto",
                      

                      h3("Animals explorer"),

                      
                      # Select the animal types
                      radioButtons(inputId = "animal_type", 
                                   label = "Animal Types",
                                   choices = c(unique(park_animals$iconic_taxon_name)), 
                                   selected = 1),
                      
                      # selectInput(inputId = "animal_type", 
                      #             label = "Animal Types",
                      #             choices = c(unique(animal$iconic_taxon_name))
                      #             ),
                      
                      
                      
                      # select the specices
                      selectInput(inputId = "species",
                                  label = "Animal Specices",
                                  choices = c("--Select--",
                                              unique(park_animals$common_name))
                                    ),
                      
                      # Not sure what this does
                      conditionalPanel("input.animal_type == 'Ave' || input.species == 'Allen's Hummingbird")

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