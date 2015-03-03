library(shiny)

shinyUI(fluidPage(
    titlePanel("Kmeans clustering demo"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("k", "Number of clusters:", min= 1, max = 10, value=2)
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
))
