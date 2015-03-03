library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {
    output$plot = renderPlot({
        dat = tbl_df(iris) %>% select(-Species)
        result = kmeans(dat, input$k)
        dat = cbind(dat, cluster=result$cluster)
        qplot(Sepal.Length, Sepal.Width, data=dat, color=factor(cluster))
    })
})

