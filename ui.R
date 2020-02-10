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
        sidebarPanel(
          "Select your interested animals:, and some certain species"
        ),
        mainPanel(
          "here is the map including selected animals distribution"
        )
      )
      # -------END Tab 3---------------
      
      
    )

# ---------END Navbar-------------------
 
 
  )
# -------END Fluid page-----------------
  
)
# =========END APP======================