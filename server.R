# Load the necessary packages
library(shiny)
library(dplyr)
library(plotly)
library(DT)
library(rsconnect)

data <- read.csv("Clean_data.csv", check.names = FALSE) %>%
  mutate(`Reference` = paste0("<a href='", `Links`, "' target='_blank'>", `Reference`, "</a>")) %>%
  select(-Links)   # remove the Links column

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