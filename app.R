# Load the necessary packages
library(shiny)
library(dplyr)
library(plotly)
library(DT)
library(rsconnect)

data <- read.csv("Clean_data.csv", check.names = FALSE) %>%
    mutate(`Reference` = paste0("<a href='", `Links`, "' target='_blank'>", `Reference`, "</a>")) %>%
    select(-Links) # 

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


server <- function(input, output) {
    output$table <- renderDataTable({
        # Apply filter conditions
        filtered_data <- data
        if (input$name_input != "None") {
            filtered_data <- filtered_data %>%
                filter(`Name of Researcher` == input$name_input)
        }
        if (input$institution_input != "None") {
            filtered_data <- filtered_data %>%
                filter(`Name of Institution` == input$institution_input)
        }

        # Sort by name and institution if both are set to "None"
        if (input$name_input == "None" && input$institution_input == "None") {
            filtered_data <- filtered_data[order(tolower(filtered_data$`Name of Researcher`), tolower(filtered_data$`Name of Institution`)), ]
        }

        # Render data table
        datatable(filtered_data, rownames = FALSE, options = list(
            pageLength = 5,
            lengthMenu = list(c(5, 10, 25, 50, -1), c("5", "10", "25", "50", "All"))
        ), escape = FALSE) # Allow HTML content rendering
    })

    output$pie_chart <- renderPlotly({
        institution_counts <- data %>% count(`Name of Institution`)
        plot_ly(institution_counts, labels = ~`Name of Institution`, values = ~n, type = "pie") %>%
            layout(title = "Number of Researchers by Institution")
    })
}

# Run the app
shinyApp(ui = ui, server = server)

# upload to shinyapps.io
rsconnect::setAccountInfo(name = "lcf9k8-haitao0shi", token = "", secret = "")

