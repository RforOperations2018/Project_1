#loading libraries
library(shiny)
library(shinydashboard)
library(reshape2)
library(dplyr)
library(plotly)
library(shinythemes)

Raw.Death.data <- read.csv("NCHS_-_Leading_Causes_of_Death__United_States.csv")
Raw.Death.data$Year <- factor(Raw.Death.data$Year)
State.Death.data <- Raw.Death.data %>% filter(State != "United States") %>% droplevels()
Country.Death.data <- filter(Raw.Death.data, State == "United States")
# created header along with dropdown menu items
header <- dashboardHeader(title = "Deaths in America")
# header <- dashboardHeader(title = "Deaths in America",
#                           dropdownMenu(type = "notifications",
#                                        notificationItem(text = "BE CAREFUL!",
#                                                         icon = icon("users"))
#                                        ),
#                           dropdownMenu(type = "tasks",
#                                        taskItem(value = 50, text = "Avoid cliffs",
#                                                 color = "purple", "Percentage")
#                                        ),
#                           dropdownMenu(type = "messages",
#                                        messageItem(
#                                          from = "Dr. Spaceman",
#                                          message = HTML("The expiration date is not a suggestion!"),
#                                          icon = icon("exclamation point"))
#                                        )
#                           )
# created sidebar with inputs
sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "tabs",
    menuItem("Plots", icon = icon("bar-chart"), tabname = "plot"),
    menuItem("Death Data Table",icon = icon("table"), tabname = "datatable"),
    radioButtons("cause",
                "Pick a cause of death: ",
                choices = unique(State.Death.data$Cause.Name),
                #multiple = FALSE,
                #selectize = TRUE,
                selected = "Alzheimer's disease"
                ),
    selectInput("state",
                "State:",
                choices = sort(unique(State.Death.data$State)),
                multiple = TRUE,
                selectize = TRUE,
                selected = "Alabama"),
    selectInput("year", 
                 "Pick a Year: ",
                 choices = sort(unique(State.Death.data$Year)),
                 multiple = FALSE,
                 selectize = TRUE,
                 selected = 1999
                )
          )
)
body <- dashboardBody(
  tabItems(
    tabItem("plot",
            # fluidRow(
            #   infoBoxOutput("mass"),
            #   valueBoxOutput("height")
            # ),
            fluidRow(
              tabBox(title = "Plot",
                     width = 12,
                     tabPanel("Cumulative Deaths", plotOutput("plot1")),
                     tabPanel("Death Rate", plotOutput("plot2")),
                     tabPanel("Time Plot", plotOutput("plot3")))
            )
    ),
    tabItem("datatable",
            fluidPage(
              box(title = "Selected Character Stats", DT::dataTableOutput("datatable"), width = 12))
    )
  ) 
)
            #             tabItem("plot", 
            #                  # fluidRow(
            #                  #    infoBoxOutput("total"),
            #                  #    valueBoxOutput("rate"),
            #                  #    valueBoxOutput("Yes or No")
            #                  #  ),
            #                  fluidRow(
            #                     tabBox(title = "Plots",
            #                       width = 12,
            #                       tabPanel("Cumulative Deaths", plotOutput("plot1")),
            #                       tabPanel("Death Rate", plotOutput("plot2")),
            #                       tabPanel("Time Plot", plotOutput("plot3"))
            #                       ))),
            #            tabItem("datatable",
            #                   fluidPage(
            #                     tabBox(title = "Death Data Table", DT::dataTableOutput("datatable"), width = 12)))
            #           
            # )

# Define UI for shiny dashboard
ui <- dashboardPage(header, sidebar, body)

# Define server logic required to draw a histogram
server <- function(input, output) {
  #Reactive Elements 
  deathInput <- reactive ({
     State.Death.data %>% filter(Year == input$year & Cause.Name == input$cause & State %in% input$State)
   })
  
  totaldeathInput <- reactive({
    Country.Death.data %>% filter( input$year == Year & input$cause == Cause.Name & State %in% input$State)
  })
   #Gauges and Infoboxes
  # totaldeathInput
  # output$total <- renderInfoBox({
  #   sw <- totaldeathInput()
  #   
  #   
  #   infoBox("Avg Mass", value = num, subtitle = paste(nrow(sw), "characters"), icon = icon("balance-scale"), color = "purple")
  # })
  # # Height mean value box
  # output$height <- renderValueBox({
  #   sw <- swInput()
  #   num <- round(mean(sw$height, na.rm = T), 2)
  #   
  #   valueBox(subtitle = "Avg Height", value = num, icon = icon("sort-numeric-asc"), color = "green")
  # })
   
   #Create Plot that Maps Total Deaths for a Particular Cause across all 50 states  
   output$plot1 <- renderPlot({
     df2 <- deathInput()
     ggplot(df2, aes(x = State, y = Deaths, color = State)) + 
       geom_bar(stat = "identity") + 
       ggtitle("Total Deaths per Accident per Year") + 
       ylab("Total Deaths") +
       theme(axis.text.x = element_text(angle = 90, hjust = 1))
     })
   
   #Create Plot that Maps the Age Adjusted Death Rate for a Particular Cause across all 50 states
  output$plot2 <-  renderPlot({
    df3 <- deathInput()
    ggplot(df3, aes(x = State, y = Age.adjusted.Death.Rate, color = State)) + 
      geom_bar(stat = "identity") + 
      ggtitle("Death Rate (per 100,000) per Accident per Year") + 
      ylab("Adjusted Death Rate")
  })
  
  output$plot3 <-  renderPlot({
    df4 <- deathInput()
    ggplot(df4, aes(x = Year, y = Age.adjusted.Death.Rate)) + 
      geom_bar(stat = "identity") + 
      ggtitle("Death Rate (per 100,000) per Accident per Year") + 
      ylab("Adjusted Death Rate")
  })
  # Create a Data
  output$datatable <- DT::renderDataTable({
    subset(deathInput(), select = c(State, Cause.Name, Deaths, Age.adjusted.Death.Rate))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


# State.Death.data %>% filter(Year == 2016 & Cause.Name == "Alzheimer's disease") %>% 
# ggplot(aes(x = State, y = Deaths)) + geom_bar(stat = 'identity')
#practice.data1$Year <- factor(practice.data1$Year)
#filter(practice.data1, State == "Alabama" & Cause.Name == "Alzheimer's disease") %>% 
# ggplot(aes(x = Year, y = Deaths, group=1)) + geom_line()

