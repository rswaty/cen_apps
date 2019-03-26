#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)



# Use a fluid Bootstrap layout
ui <- fluidPage(theme = shinytheme("superhero"),    
                
                # Give the page a title
                titlePanel("Central Appalachian Focal Landscapes VDEP Explorer"),
                
                # Generate a row with a sidebar
                sidebarLayout(      
                  
                  # Define the sidebar with one input
                  sidebarPanel(
                    h2("Select a Biophysical Setting:"),
                    
                    selectInput("bps", label = "BiophysicalSetting", choices = tidyRC$`bps`),
                    
                    hr(),
                    helpText("The LANDFIRE program generates and delivers dozens of spatial datasets, 
               800+ ecosystem models and descriptions.  We used the Annual Disturbance datasets from 1999-2014
               for this app.")
                  ),
                  
                  # Create a spot for the barplot
                  mainPanel(
                    plotOutput("distPlot", height = 500),
                    p("This simple app was built to illustrate the potential of LANDFIRE data.  For more information on LANDFIRE visit ",
                      a("the LANDFIRE homepage.", 
                        href = "https://landfire.gov/"))
                  )
                  
                )
) 

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  #data manipulation
  filtered_data <- reactive({
    tidyRC %>% 
      filter(bps==input$bps)
  })
  
  
  
  # Fill in the spot we created for a plot
  output$distPlot <- renderPlot({
    
    # Render a ggplot2 stacked area plot based for selected state with "DISTURBANCE"  as the fill parameter
    filtered_data()%>%
      ggplot(aes(x=scls, y=percent, fill=ref_cur))+
      geom_bar(position="dodge", stat= "identity") 
    
    
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

