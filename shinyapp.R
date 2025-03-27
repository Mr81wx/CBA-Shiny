#加载包
library(shiny)
require(shinythemes)
require(tidyverse)
require(extrafont)

#加载数据
Player_data<-read.csv("player_shiny.csv")
plot_data<-read.csv("cluster_zuobiao.csv")

# Define UI for app that draws a histogram ----
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("CBA Player"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    selectInput("variable", "球员:", 
                c("郭艾伦" = "Ailun Guo",
                  "易建联" = "Jianlian Yi",
                  "周琦" = "Qi Zhou")),
    checkboxInput("outliers", "Show outliers", TRUE)
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    # Output: Formatted text for caption ----
    h3(textOutput("caption")),
    
    # Output: Plot of the requested variable against mpg ----
    plotOutput("mpgPlot")
    
  )
)



mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))
server <- function(input, output) {
  formulaText <- reactive({
    paste("球员 ~", input$variable)
  })
  
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the requested variable against mpg ----
  # and only exclude outliers if requested
  output$mpgPlot <- renderPlot({
    plot()
  })
}

shinyApp(ui, server)
