# Load the necessary packages
library(shiny)
library(DT)
library(dplyr)

# Read the data
data <- read.csv("Clean_data.csv", check.names = FALSE) 

# Define the user interface
ui <- fluidPage(
    titlePanel("Drugs Research Network Scotland: Mapping of drugs research 2013-2023"),
    sidebarLayout(
        sidebarPanel(
            selectInput("name_input", "Name of Researcher", choices = c("None", sort(unique(data$`Name of Researcher`)))),
            selectInput("institution_input", "Name of Institution", choices = c("None", sort(unique(data$`Name of Institution`))))
        ),
        mainPanel(
            DTOutput("table")
        )
    )
)

# Define the server logic
server <- function(input, output) {
    output$table <- renderDT({
        filtered_data <- data
        if (input$name_input != "None") {
            filtered_data <- filtered_data[filtered_data$`Name of Researcher` == input$name_input, ]
        }
        if (input$institution_input != "None") {
            filtered_data <- filtered_data[filtered_data$`Name of Institution` == input$institution_input, ]
        }
        datatable(filtered_data, options = list(pageLength = 5))
    })
}

# Run the app
shinyApp(ui = ui, server = server)

