#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(reshape2)
library(dplyr)
library(plotly)
library(shinythemes)

Death_data <- read.csv("NCHS_-_Leading_Causes_of_Death__United_States.csv")
mapDetails <- list(scope = 'usa',
                   projection = list(type = 'albers usa'),
                   showlakes = TRUE,
                   lakecolor = toRGB('white')
                   )

# created header along with dropdown menu items
header <- dashboardHeader(title = "Project 1",
                          dropdownMenu(type = "notifications",
                                       notificationItem(text = "help",
                                                        icon = icon("users"))
                                       ),
                          dropdownMenu(type = "tasks",
                                       taskItem(value = 50, text = "Try",
                                                color = "purple", "Percentage")
                                       ),
                          dropdownMenu(type = "messages",
                                       messageItem(
                                         from = "Barack Obama",
                                         message = HTML("Change we can believe in"),
                                         icon = icon("exclamation point"))
                                       )
                          )
# created sidebar (will put in inputs later)
sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "tabs",
    menuItem("Maps", icon = icon("map"), tabname = "map1"),
    menuItem("Plots", icon = icon("chart-line"), tabname = "plot2"),
    menuItem("Death Data Table", icon = icon("table"), tabname = "table"),
    selectInput("year", 
                "Pick a Year: ",
                choices = sort(unique(Death_data$Year)),
                multiple = FALSE,
                selectize = TRUE,
                selected = 2006
                )
              )
            )
body <- dashboardBody(tabItems(
                      tabItem("map1", 
                              fluidRow(
                                infoBoxOutput("Overall Deaths"),
                                valueBoxOutput("Average Death Rate")
                              ),
                              fluidRow(
                                tabBox(title = "Maps",
                                  width = 12,
                                  selectInput("cause",
                                              "Pick a cause of death: ",
                                              choices = sort(unique(Death_data$Cause.Name)),
                                              multiple = FALSE,
                                              selectize = TRUE,
                                              selected = "All causes"
                                  ),
                                  tabPanel("totaldeathmap", plotlyOutput("df1.map")),
                                  tabPanel("deathratemap", plotlyOutput("df2.map"))
                                  )
                                )
                              )
                      )
                    )
# Define UI for shiny dashboard
ui <- dashboardPage(header, sidebar, body)

# Define server logic required to draw a histogram
server <- function(input, output) {
   # deathInput <- reactive ({
   #   Death_data %>% filter( input$year == Year & input$cause == Cause.Name)
   # })
   # output$heatmap <- renderPlotly({
   #   df1 <- deathInput()
   # })
   # 
}

# Run the application 
shinyApp(ui = ui, server = server)

