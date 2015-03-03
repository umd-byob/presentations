library(shiny)

shinyUI(fluidPage(
    titlePanel("Shiny demo #2: RNA-Seq normalization methods"),
    sidebarLayout(
        sidebarPanel(
            selectInput("norm_method", "Normalization method:",
                        c("None" = "none",
                          "Size Factor Normalization" = "size_factor",
                          "Quantile Normalization" = "quantile")),
            width=2
        ),
        mainPanel(
            plotOutput("count_distributions"),
            dataTableOutput('metadata_table')

        )
    )
))
