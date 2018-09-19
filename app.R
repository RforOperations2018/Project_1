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
sidebar <- dashboardSidebar(sidebarMenu(id = "tabs",
                                        menuItem("Plot.1", icon = icon("bar-chart"), tabname = "Plot1"),
                                        menuItem("Plot.2", icon = icon("bar-chart"), tabname = "Plot2"),
                                        menuItem("Plot.3", icon = icon("bar-chart"), tabname = "Plot3")
                                        )
                            )
body <- dashboardBody(tabItems(
                      tabItem("Plot1", 
                              fluidRow(),
                              fluidRow(
                                tabBox(
                                  tabPanel(),
                                  tabPanel()
                                  )
                                )
                              )
                      )
                      )
# Define UI for shiny dashboard
ui <- dashboard(header, sidebar, body)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
}

# Run the application 
shinyApp(ui = ui, server = server)

