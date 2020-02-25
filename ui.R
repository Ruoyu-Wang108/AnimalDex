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
        
        # map output
        leafletOutput("basemap", width = "100%", height = 600),
        
        # ------absolute panel------------
        # absolutePanel(id = "controls", 
        #               class = "panel panel-default", 
        #               fixed = TRUE,
        #               draggable = TRUE, 
        #               top = 60, 
        #               left = "auto", 
        #               right = 20, bottom = "auto",
        #               width = 330, height = "auto",
        #               
        #               h2("Animals explorer"),
        #               
        #               selectInput("color", "Color", vars), 
        #               # ours are not change the color but to change the filter for animal types
        #               
        #               selectInput("size", "Size", vars, selected = "adultpop"), 
        #               # here we should select the specices
        #               
        #               conditionalPanel("input.color == 'superzip' || input.size == 'superzip'", 5)
        #               
        # )
        #------ END absulute panel ----------------------
        
        
      )
      # -------END Tab 3---------------
      
      
    )

# ---------END Navbar-------------------
 
 
  )
# -------END Fluid page-----------------
  
)
# =========END APP======================