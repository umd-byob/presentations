library(shiny)

shinyUI(fluidPage(
    titlePanel("Hello Shiny!"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("k", "Number of clusters:", min= 1, max = 10, value=2)
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
))
