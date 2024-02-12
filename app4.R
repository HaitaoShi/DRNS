# Load the necessary packages
library(shiny)
library(dplyr)
library(plotly)
library(DT)

# Read the data
data <- read.csv("Clean_data.csv", check.names = FALSE) 

# user interface
ui <- fluidPage(
    titlePanel("Drugs Research Network Scotland: Mapping of drugs research 2013-2023"),
    tags$head(
        tags$style(HTML("
            .dataTable .odd {
                background-color: #E6E6FA; /* Light purple for odd rows */
            }
            .dataTable .even {
                background-color: #f2f2f2; /* Light grey for even rows */
            }
            .dataTable thead tr {
                background-color: #f2f2f2; /* Light grey for column headers */
            }
 
        "))
    ),
    sidebarLayout(
        sidebarPanel(
            selectInput("name_input", "Name of Researcher", choices = c("None", sort(unique(data$`Name of Researcher`)))),
            selectInput("institution_input", "Name of Institution", choices = c("None", sort(unique(data$`Name of Institution`))))
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Table", dataTableOutput("table")),
                tabPanel("Pie Chart", plotlyOutput("pie_chart"))
            )
        )
    )
)


# server function
server <- function(input, output) {
    output$table <- renderDataTable({
        if (input$name_input == "None" && input$institution_input == "None") {
            data %>%
            arrange(`Name of Researcher`, `Name of Institution`)
        } else if (input$name_input == "None") {
            subset(data, `Name of Institution` == input$institution_input) %>%
            arrange(`Name of Researcher`)
        } else if (input$institution_input == "None") {
            subset(data, `Name of Researcher` == input$name_input) %>%
            arrange(`Name of Institution`)
        } else {
            subset(data, `Name of Researcher` == input$name_input & `Name of Institution` == input$institution_input) %>%
            arrange(`Name of Researcher`, `Name of Institution`)
        }
    }, options = list(
        pageLength = 5,  # Set default page length to 5
        lengthMenu = list(c(5, 10, 25, 50, -1), c('5', '10', '25', '50', 'All'))  # Customize page length options
    ))
    
    output$pie_chart <- renderPlotly({
        institution_counts <- data %>% count(`Name of Institution`)
        plot_ly(institution_counts, labels = ~`Name of Institution`, values = ~n, type = 'pie') %>%
        layout(title = "Number of Researchers by Institution")
    })
}

# Run the app
shinyApp(ui = ui, server = server)

