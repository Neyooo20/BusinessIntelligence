#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Load the dataset
data <- read.csv("~/Downloads/archive (2)/airline delay causes1.csv")
colnames(data) <- trimws(colnames(data)) # Clean column names


# Example dataset with monthly arrivals data
flights_data <- data.frame(
  airport_name = c("Airport A", "Airport B", "Airport C", "Airport D", "Airport E"),
  month = c(1, 1, 1, 2, 2),
  year = c(2023, 2023, 2023, 2023, 2023),
  arrivals_per_month = c(150, 200, 180, 210, 220)
)

# UI for the app
ui <- fluidPage(
  titlePanel("Airport Arrivals per Month and Year"),
  
  sidebarLayout(
    sidebarPanel(
      # Slider input to select the month
      sliderInput("month_slider",
                  "Select the month:",
                  min = 1,
                  max = 12,
                  value = 1,
                  step = 1,
                  animate = TRUE),
      
      # Slider input to select the year
      sliderInput("year_slider",
                  "Select the year:",
                  min = min(data$year),
                  max = max(data$year),
                  value = 2023,
                  step = 1,
                  animate = TRUE),
      
      # Display the selected month and year
      textOutput("selected_month_year")
    ),
    
    mainPanel(
      # Output the filtered airport data (name and total arrivals)
      tableOutput("airport_data")
    )
  )
)

# Server function
server <- function(input, output) {
  
  # Reactive expression to filter airports based on selected month and year
  filtered_airports <- reactive({
    subset(data,
           month == input$month_slider & year == input$year_slider)
  })
  
  # Render the filtered data in a table
  output$airport_data <- renderTable({
    filtered_airports()
  })
  
  # Render the text to show the selected month and year
  output$selected_month_year <- renderText({
    paste("Selected month:", input$month_slider, "Year:", input$year_slider)
  })
}

# Run the application
shinyApp(ui = ui, server = server)