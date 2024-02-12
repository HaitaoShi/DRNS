# Load the necessary packages
library(shiny)
library(dplyr)
library(plotly)
library(DT)
library(rsconnect)

data <- read.csv("Clean_data.csv", check.names = FALSE) %>%
  mutate(`Reference` = paste0("<a href='", `Links`, "' target='_blank'>", `Reference`, "</a>")) %>%
  select(-Links)   # remove the Links column


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