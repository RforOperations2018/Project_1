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
library(fiftystater)
library(maps)
#Read Data
Raw.Death.data <- read.csv("NCHS_-_Leading_Causes_of_Death__United_States.csv")
#Filter Data to only includ states
State.Death.data <- filter(Raw.Death.data, State != "United States")

# death_data_proto <- filter(State.Death.data, year == 2016 & cause.name == "Alzheimer's disease")
# 
# Load US Data
# states1 <- map_data("usa")
# data("fifty_states")
# Format Data 
names(State.Death.data) <- tolower(names(State.Death.data))
State.Death.data$State <- tolower(State.Death.data$state)

# 
# p

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
                choices = sort(unique(State.Death.data$year)),
                multiple = FALSE,
                selectize = TRUE,
                selected = 2006
                ),
    selectInput("cause",
                "Pick a cause of death: ",
                choices = sort(unique(State.Death.data$cause.name)),
                multiple = FALSE,
                selectize = TRUE,
                selected = "Alzheimers"
                )
    
              )
            )
body <- dashboardBody(tabItem("map1", 
                              # fluidRow(
                              #   infoBoxOutput("Overall Deaths"),
                              #   valueBoxOutput("Average Death Rate")
                              # ),
                              fluidRow(
                                infoBoxOutput("total"),
                                valueBoxOutput("rate")
                              ),
                              fluidRow(
                                tabBox(title = "Maps",
                                  width = 12,
                                  # selectInput("cause",
                                  #             "Pick a cause of death: ",
                                  #             choices = sort(unique(State.Death.data$cause.name)),
                                  #             multiple = FALSE,
                                  #             selectize = TRUE,
                                  #             selected = "Alzheimers"
                                  # ),
                                  tabPanel(title = "totaldeathmap", plotOutput("heatmap1")),
                                  tabPanel(title = "deathratemap", plotOutput("df2.map"))
                                  ))),
                      tabItem(title = "plots1",
                              tabBox(title = "Plots",
                                     width  = 12, 
                              tabPanel(title = "plot", plotOutput("practice1")),
                                 tabPanel(title = "plot2", plotOutput("practice2"))
                                ),
                      tabItem(title = "datatable",
                              tabBox(title = "Datatable",
                                     width = 12,
                                tabPanel(title = "only1datatable", dataTableOutput("table")))
                      )
            )
)
# Define UI for shiny dashboard
ui <- dashboardPage(header, sidebar, body)

# Define server logic required to draw a histogram
server <- function(input, output) {
   deathInput <- reactive ({
     State.Death.data %>% filter( input$year == year & input$cause == cause.name)
   })
   output$heatmap1 <- renderPlot({
     df1 <- deathInput()
     states1 <- map_data("usa")
     data("fifty_states")
     ggplot(df1, aes(map_id = state)) +
       # map points to the fifty_states shape data
       geom_map(aes(fill = deaths), map = fifty_states) +
       expand_limits(x = fifty_states$long, y = fifty_states$lat) +
       coord_map() +
       scale_x_continuous(breaks = NULL) +
       scale_y_continuous(breaks = NULL) +
       scale_fill_gradient(low = "#56B1F7", high = "#132B43") +
       labs(x = "", y = "") +
       theme(legend.position = "right",
             panel.background = element_blank())
     
   })

}

# Run the application 
shinyApp(ui = ui, server = server)

